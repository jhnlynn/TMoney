import datetime

import streamlit as st
import streamlit.components.v1 as components
from collections import OrderedDict
import psycopg2
import streamlit as st
from configparser import ConfigParser
import pandas as pd
import numpy as np
import altair as alt
from time import gmtime, strftime
import plotly.express as px
import json

st.set_page_config(layout="wide")


@st.cache
def get_config(filename="database.ini", section="postgresql"):
    parser = ConfigParser()
    parser.read(filename)
    return {k: v for k, v in parser.items(section)}


@st.cache(allow_output_mutation=True)
def query_db(sql: str):

    db_info = get_config()

    # Connect to an existing database
    conn = psycopg2.connect(**db_info)

    # Open a cursor to perform database operations
    cur = conn.cursor()

    # Execute a command: this creates a new table
    cur.execute(sql)

    # Obtain data
    data = cur.fetchall()

    column_names = [desc[0] for desc in cur.description]

    # Make the changes to the database persistent
    conn.commit()

    # Close communication with the database
    cur.close()
    conn.close()

    df = pd.DataFrame(data=data, columns=column_names)

    return df


# instead of fetching all, we execute sql here
def exe_db(sql: str):
    db_info = get_config()

    # Connect to an existing database
    conn = psycopg2.connect(**db_info)

    # Open a cursor to perform database operations
    cur = conn.cursor()

    # Execute a command: this creates a new table
    cur.execute(sql)

    # Make the changes to the database persistent
    conn.commit()

    # Close communication with the database
    cur.close()
    conn.close()


def parse_df_2_json(df):
    to_json = df.to_json(orient="table")
    parsed = json.loads(to_json)
    return parsed['data']


def chat_hist_display(parsed, user_id):
    """

    :param parsed: json format, you should use function `parse_df_2_json` to parse df to json, and then pass json format in
    :param user_id: sender_id
    :return:
    """
    components.html(
        """
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" crossorigin="anonymous">
        <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" crossorigin="anonymous"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js" crossorigin="anonymous"></script>
        <style>
            .msg-bubble {
        max-width: 450px;
        padding: 15px;
        border-radius: 15px;
      }
    
      .msg {
        display: flex;
        align-items: flex-end;
        margin-bottom: 10px;
      }
    
      .left-msg {
          flex-direction: row;
      }
    
      .right-msg {
        flex-direction: row-reverse;
      }
    
        </style>
        <main class="msger-chat">
            <li id="messages">
                <ul id="left-msg"></ul>
                <ul id="right-msg"></ul>
            </li>
        </main>
        <script>
            const messages = 
            
    """
        + str(parsed)
        +
        """
        
        const user_id = """ + str(user_id) + """
        
        const config = {
          BubbleTemplate: (name, text, send_time) => {
            return `
                        <div class="msg-bubble">
                            <div>
                                user: ${name}
                            </div>
                            <div>
                              ${send_time}
                            </div>
                            <div>
                                ${text}
                            </div>
                        </div>
                `
          },
        }
        
        const { BubbleTemplate } = config
        
        const singleMessageDisplay = (message) => {
          if (message.user_id === user_id) {
            const div = document.createElement('div')
            div.className = 'msg right-msg'
            div.innerHTML = BubbleTemplate(message.name, message.content, message.send_time)
            document.getElementById('messages').appendChild(div)
          } else {
            const div = document.createElement('div')
            div.className = 'msg left-msg'
            div.innerHTML = BubbleTemplate(message.name, message.content, message.send_time)
            document.getElementById('messages').appendChild(div)
          }
        }
        
        
        messages.forEach((message) => {
          singleMessageDisplay(message)
        })
        
            </script>
            """,
        height=300,
        scrolling=True
    )


def contact_block(user_id):
    return query_db(f'select blocked_user_id from contact_limitation where user_id = {user_id};')


def contact():
    # for certain date range selection
    earliest_date = query_db('select min(send_time) as send_time from message')['send_time'].tolist()[0].date()
    # initialize as the earliest date among all messages' send_time
    start_date = st.sidebar.date_input('Start Date', earliest_date)
    end_date = st.sidebar.date_input('End Date', datetime.date(2022, 12, 31))

    if start_date > end_date:
        st.error('The start date must be earlier than end date', icon='🚨')
        return

    # find all users from account
    sql_all_users = 'select id, name from account;'
    user_query = query_db(sql_all_users)
    name_list, id_list = user_query['name'], user_query['id']
    combined_dict = {n: i for n, i in zip(name_list, id_list)}
    username = st.sidebar.selectbox('Users', [n for n in name_list])
    sender_id = combined_dict[username]
    sql_contact = f'''
        select a.id, a.name as username, a.email, a.education, a.age, a.gender, a.profession, c.created_time as be_friend_from from contact c, account a where c.receiver_id = a.id
        and c.sender_id = {sender_id} order by be_friend_from;
    '''
    # here we get all contact that user possess, with which the user has chat history with
    sql_all_messages = f'''
    select a.id from
    (
    select distinct m.sender_id as id from message as m where m.receiver_id = {sender_id} and m.send_time > '{start_date}' and m.send_time < '{end_date}'
    union
    select distinct m.receiver_id as id from message as m where m.sender_id = {sender_id} and m.send_time > '{start_date}' and m.send_time < '{end_date}'
    ) as tm join account a on tm.id = a.id;
    '''
    df = query_db(sql_contact)
    intersection_list = query_db(sql_all_messages)['id'].tolist()
    intersection_hs = set(intersection_list)

    # check for blocked contact in the perspective of the current user
    blocked_id = contact_block(sender_id)
    blocked_set = set(blocked_id['blocked_user_id'].tolist())

    if df.empty:
        st.write('### This User Has No Contact Book Yet')

    for i in range(len(df)):
        # only display contact name
        receiver_id = df.iloc[i, 0]

        chat_hist = query_db(f'''
        select m.send_time, a.name, m.content, a.id as user_id from message as m join account as a
        on m.receiver_id = a.id
        where ((m.sender_id = {sender_id} and m.receiver_id = {receiver_id}) or (m.sender_id = {receiver_id} and m.receiver_id = {sender_id}))
        and m.send_time > '{start_date}' and m.send_time < '{end_date}'
        order by m.send_time;
        ''')
        # show something different, for blocked contact
        expander = st.expander('{}'.format(df.iloc[i, 1] + (' [BLOCKED]' if receiver_id in blocked_set else '')),
                               expanded=False)
        with expander:
            if chat_hist.empty or receiver_id not in intersection_hs or receiver_id in blocked_set:
                st.write('### No Chat History for This User During This Time Interval')
                continue
            chat_hist_display(parse_df_2_json(chat_hist), sender_id)


def users():
    dic = {
        '0-9':(0,9),
        '10-19': (10, 19),
        '20-29': (20, 29),
        '30-39': (30, 39),
        '40-49': (40, 49),
        '50-59': (50, 59),
        '60-69': (60, 69),
        '70-79': (70, 79),
        '80-89': (80, 89),
        '90-99': (90, 99),
        '100-109': (100, 109),
    }
    temp_dic = []
    for ch in dic.keys():
        temp_dic.append(ch)
    sql_user_names = "SELECT name FROM account ORDER BY name;"
    sql_email = "SELECT email FROM account ORDER BY name"
    sql_join_date = "SELECT distinct join_date FROM account ORDER BY join_date"
    #sql_age = "SELECT distinct age FROM account ORDER BY age"
    sql_gender = "SELECT distinct gender FROM account ORDER BY gender"
    sql_education = "SELECT distinct education FROM account ORDER BY education"
    sql_profession = "SELECT distinct profession FROM account ORDER BY profession"
    userName = st.sidebar.text_input("User Name")
    email = st.sidebar.text_input("User Email")
    join_date = st.sidebar.selectbox("Join Date", ["All dates"] + query_db(sql_join_date)["join_date"].tolist())

    age = st.sidebar.selectbox("Age", ["All ages"]+temp_dic)
    #age = st.sidebar.selectbox("Age", ["All ages"]+query_db(sql_age)["age"].tolist())
    gender = st.sidebar.selectbox("Gender", ["All genders"]+query_db(sql_gender)["gender"].tolist())
    education = st.sidebar.selectbox("Education", ["All educations"]+query_db(sql_education)["education"].tolist())
    profession = st.sidebar.selectbox("Profession", ["All professions"] + query_db(sql_profession)["profession"].tolist())
    sql_users = "SELECT a.name, a.age, a.gender, a.education, a.profession, a.id FROM account a"
    conditions = []
    if userName:
        conditions.append(" lower(a.name) LIKE lower('%{}%')".format(userName))
    if email:
        conditions.append(" a.email LIKE '%{}%'".format(email))
    if join_date != "All dates":
        conditions.append(" a.join_date = '{}'".format(join_date))
    if age != "All ages":
        a,b = dic[age][0],dic[age][1]
        conditions.append(" (a.age >= '{}' ".format(a) + "and a.age <= '{}' )".format(b))
    if gender != "All genders":
        conditions.append(" a.gender = '{}'".format(gender))
    if education != "All educations":
        conditions.append(" a.education = '{}'".format(education))
    if profession != "All professions":
        conditions.append(" a.professions = '{}'".format(profession))
    if conditions:
        sql_users += " WHERE "
        sql_users += " AND ".join(conditions)

    sql_users += " ORDER BY name;"

    df = query_db(sql_users)
    # create view on account-company-payment trinary
    create_view_on_user_company_payment()
    if df.empty:
        st.write('### No users for this filter')
    else:
        for i in range(len(df)):
            my_expander = st.expander("{}".format(df.iloc[i,0]), expanded=False)
            with my_expander:
                render_user_page(df.iloc[i,0],)
                payment_spending_report(df.iloc[i,5])


#email, join_date, age, gender, education, profession
def render_user_page(name):
    sql_user_info = f"SELECT * FROM account WHERE name = '{name}';"
    user_info = query_db(sql_user_info)
    st.write("# {}".format(name))
    st.markdown(f"""
        ## :memo: Info
        * Name: {user_info['name'].values[0]}
        * Email: {user_info['email'].values[0]}
        * Join_date: {user_info['join_date'].values[0]}
        * Age: {user_info['age'].values[0]}
        * Gender: {user_info['gender'].values[0]}
        * Education: {user_info['education'].values[0]}
        * Profession: {user_info['profession'].values[0]}
        """)


def render_payment_merchant_page(user_id, merchant_id, merchant_name, start_date, end_date):
    sql_all_transactions = f'''
        select p.payment_name as transaction_name, p.sending_time, cast(p.amount as decimal(9,2))/100 as amount, p.comment, p.method, c.name, c.headline as category, c.location as merchant_location 
        from payment p join company c on p.receiver_id = c.id
        where p.user_id = {user_id} and c.id = {merchant_id}
        and p.sending_time > '{start_date}' and p.sending_time < '{end_date}';
        '''
    sql_merchant_info = f'''
            select c.name, c.headline, c.location, c.about from company c where c.id = {merchant_id};
        '''
    sql_user_payment_amount_cylinder_chart = f'''
                select p.payment_name, p.sending_time, cast(p.amount as decimal(9,2))/100 as total_amount, c.headline as category, c.location 
                from payment p join company c on p.receiver_id = c.id
                where p.user_id = {user_id} and c.id = {merchant_id}
                and p.sending_time > '{start_date}' and p.sending_time < '{end_date}';
    '''
    sql_amount_to_merchant = f'''
    select cast(sum(p.amount) as decimal(9,2))/100 as subtotal from payment p left join company c on p.receiver_id = c.id
    where p.user_id = {user_id} and c.id = {merchant_id}
    and p.sending_time > '{start_date}' and p.sending_time < '{end_date}';
    '''

    merchant_info                   = query_db(sql_merchant_info)
    payment_amount_cylinder_chart   = query_db(sql_user_payment_amount_cylinder_chart)
    all_transactions                = query_db(sql_all_transactions)
    subtotal_amount                 = query_db(sql_amount_to_merchant)

    # st.img(logo)
    st.write('# {} '.format(merchant_name))
    st.markdown(f'''
    ## :rocket: Info
* Headline: {merchant_info['headline'].values[0]}
* Location: {merchant_info['location'].values[0]}
* About: \n
{merchant_info['about'].values[0]}
        ''')

    st.write('## :chart_with_upwards_trend: All Payment Transactions Cylinder')
    # cylinder chart w/ amount each transaction
    # cylinders = px.histogram(payment_amount_cylinder_chart, x='sending_time', y='total_amount',
    #                          hover_data=['payment_name', 'category', 'location'])
    cylinders = px.scatter(payment_amount_cylinder_chart, x='sending_time', y='total_amount'
                           , size=[20]*len(payment_amount_cylinder_chart), hover_data=['sending_time', 'total_amount'])
    st.plotly_chart(cylinders, use_container_width=True)

    # show the table for all transactions
    st.write('## :mag: All Payment Transactions Table')
    st.dataframe(all_transactions.style.format(subset=['amount'], formatter='{:.2f}'))

    # subtotal for all transactions to this merchant
    # print('subtotal_amount: ', subtotal_amount)
    if start_date < end_date:
        st.write('### :pencil2: subtotal for {} is {}'.format(merchant_name, round(subtotal_amount['subtotal'].tolist()[0], 2)))


def payment():
    sql_users_using_payment = 'select distinct a.id, a.name from account a, payment p where a.id = p.user_id order by a.id;'
    user_query = query_db(sql_users_using_payment)
    name_list, id_list = user_query['name'], user_query['id']
    combined_dict = {n: i for n, i in zip(name_list, id_list)}
    username = st.sidebar.selectbox('Users', [n for n in name_list])
    user_id = combined_dict[username]

    # for certain date range selection
    earliest_date = query_db('select min(sending_time) as send_time from payment')['send_time'].tolist()[0].date()
    # initialize as the earliest date among all messages' send_time
    start_date = st.sidebar.date_input('Start Date', earliest_date)
    end_date = st.sidebar.date_input('End Date', datetime.date(2022, 12, 31))

    if start_date > end_date:
        st.error('The start date must be earlier than end date', icon='🚨')
        return

    sql_user_total_transaction_amount = f'''
        select cast(sum(p.amount) as decimal(9,2))/100 as total_amount from payment p where p.user_id = {user_id}
        and p.sending_time > '{start_date}' and p.sending_time < '{end_date}';
    '''
    sql_all_merchants = f'''
    select distinct c.id, c.name from company c, payment p where c.id = p.receiver_id and p.user_id = {user_id} 
    and p.sending_time > '{start_date}' and p.sending_time < '{end_date}';
    '''
    df = query_db(sql_all_merchants)
    for i in range(len(df)):
        merchant_id = df.iloc[i, 0]
        expander = st.expander('{}'.format(df.iloc[i, 1]),
                               expanded=False)
        with expander:
            render_payment_merchant_page(user_id, merchant_id, df.iloc[i, 1], start_date, end_date)

    sql_user_payment_method_cylinder_chart = f'''
            select sum(p.amount) as total_amount, p.method
            from payment p join company c on p.receiver_id = c.id
            where p.user_id = {user_id} and p.sending_time > '{start_date}' and p.sending_time < '{end_date}'
            group by p.method;
    '''
    sql_user_payment_category_pie_chart = f'''
                select cast(sum(p.amount) as decimal(9,2))/100 as amount, c.headline as category 
                from company c, payment p where p.receiver_id = c.id and p.user_id = {user_id}
                and p.sending_time > '{start_date}' and p.sending_time < '{end_date}'
                group by c.headline;
    '''

    payment_method_cylinder_chart   = query_db(sql_user_payment_method_cylinder_chart)
    category_pie_chart              = query_db(sql_user_payment_category_pie_chart)
    user_total_amount               = query_db(sql_user_total_transaction_amount)

    # draw a pie chart here
    st.write('## User\'s Payment Category Pie Chart')
    cylinders = px.pie(category_pie_chart, values='amount', names='category')
    st.plotly_chart(cylinders, use_container_width=True)

    # draw the payment method cylinder chart
    st.write('## User\'s Payment Method Cylinder Chart')
    cylinders = px.histogram(payment_method_cylinder_chart, x='method', y='total_amount')
    st.plotly_chart(cylinders, use_container_width=True)

    # user payment transaction subtotal
    st.write('## User\'s Total Payment Amount: {}'.format(round(user_total_amount['total_amount'].tolist()[0], 2)))


def transfer():
    sql_user_transfer = 'select distinct a.id, a.name from account a, transfer p where a.id = p.user_id order by a.id;'
    user_query = query_db(sql_user_transfer)
    name_list, id_list = user_query['name'], user_query['id']
    combined_dict = {n: i for n, i in zip(name_list, id_list)}
    username = st.sidebar.selectbox('Users', [n for n in name_list])
    user_id = combined_dict[username]

    both_dates_ends_query = query_db('select min(sending_time) as start_date, max(sending_time) as end_date from transfer')
    earliest_date = both_dates_ends_query['start_date'].tolist()[0].date()
    latest_date = both_dates_ends_query['end_date'].tolist()[0].date()
    transfer_selection_dates = st.sidebar.date_input('Dates', value=[earliest_date, latest_date])

    if len(transfer_selection_dates) == 1 or transfer_selection_dates[0] >= transfer_selection_dates[1]:
        st.write('### please select two different dates')
        return

    start_date, end_date = transfer_selection_dates

    sql_all_receivers_list = f'''
        select distinct a.id, a.name from account a, transfer t where t.receiver_id = a.id 
        and t.user_id = {user_id} and t.sending_time > '{start_date}' and t.sending_time < '{end_date}';
    '''
    sql_user_total_transfer_amount = f'''
            select cast(sum(p.amount) as decimal(9,2))/100 as total_amount from transfer p where p.user_id = {user_id}
            and p.sending_time > '{start_date}' and p.sending_time < '{end_date}';
        '''
    df = query_db(sql_all_receivers_list)
    total_amount_transfer = query_db(sql_user_total_transfer_amount)

    for i in range(len(df)):
        receiver_id = df.iloc[i, 0]
        receiver_name = df.iloc[i,1]
        sql_all_transfer_single_user = f'''
            select distinct t.sending_time, t.transfer_name,
            cast(t.amount as decimal(9,2))/100 as amount, t.comment from account a, transfer t where t.receiver_id = {receiver_id} 
            and t.user_id = {user_id} and t.sending_time > '{start_date}' and t.sending_time < '{end_date}';
        '''

        st.write('## User: {} '.format(df.iloc[i, 1]))
        transfer_table = query_db(sql_all_transfer_single_user)
        st.dataframe(transfer_table.style.format(subset=['amount'], formatter='{:.2f}'))

        subtotal_each_user = f'''
            select cast(sum(p.amount) as decimal(9,2))/100 as subtotal from transfer p left join account c on p.receiver_id = c.id
            where p.user_id = {user_id} and c.id = {receiver_id}
            and p.sending_time > '{start_date}' and p.sending_time < '{end_date}';
            '''
        subtotal = query_db(subtotal_each_user)
        transfer_report(user_id)
        if not subtotal.empty:
            st.write('#### :pencil2: subtotal for {} is {}'.format(receiver_name,
                                                              round(subtotal['subtotal'].tolist()[0], 2)))
        else:
            st.write('### No Transfer for This User')

    if total_amount_transfer['total_amount'].tolist()[0]:
        st.write('## User\'s Total Payment Amount: {}'.format(round(total_amount_transfer['total_amount'].tolist()[0], 2)))
    else:
        st.write('### No Transfer During This Time')


def payment_spending_report(user_id):
    """
    it is more like a summary
    here we show plain table w/ comparison b/w set_limit during payment_limitation effective time
    and also show the total amount of all payments' amount during the effective time
    """
    sql_apply_payment_limitation = f'''
    select set_date, end_date, cast(payment_restriction as decimal (8,2))/100 as payment_restriction, 
        cast(total_spending as decimal (8,2))/100 as total_spending, 
        CASE WHEN payment_restriction < total_spending THEN 'Yes' ELSE 'No' END AS if_exceeds from
    (
    select p.set_date, (p.set_date + p.effective_days) as end_date, p.amount as payment_restriction,
            sum(t.limitation_amount) as total_spending
    from payment_limitation p, time_span_spending t
    where t.sending_time >= p.set_date and t.sending_time <= p.set_date + p.effective_days
    and p.user_id = {user_id} and t.user_id = {user_id}
    group by p.amount, p.set_date, p.effective_days
    order by p.set_date
    ) as pt;
    '''
    st.write('## User\'s Spending Restriction Report')
    # preprocessing data in dataframe format
    restriction_table = query_db(sql_apply_payment_limitation)
    if not restriction_table.empty:
        st.dataframe(restriction_table.style.format(subset=['payment_restriction', 'total_spending'], formatter='{:.2f}'))
    else:
        st.write('No Restriction Set by User')


def create_view_on_user_company_payment():
    # here we assume postgres connectors are executing following queries in order set by us
    # and can execute multiple queries separated by `;` in one run
    sql_create_view_on_user_company_payment_ternary = f'''
    drop view if exists time_span_spending cascade;
    create view time_span_spending (user_id, username, email, payment_name, sending_time, limitation_amount, 
            company_name, hrender_payment_merchant_pageeadline, location)
    as
    select a.id as user_id, a.name as username, a.email, p.payment_name, p.sending_time, p.amount as limitation_amount, 
    c.name as company_name, c.headline, c.location
    from company c, account a, payment p where a.id = p.user_id and c.id = p.receiver_id;
    '''
    exe_db(sql_create_view_on_user_company_payment_ternary)


def create_view_on_user_transfer():
    # here we assume postgres connectors are executing following queries in order set by us
    # and can execute multiple queries separated by `;` in one run
    sql_create_view_on_user_receiver_transfer_ternary = f'''
    drop view if exists time_span_transfer cascade;
    create view time_span_transfer (user_id, username, email, transfer_name, sending_time, limitation_amount,
            receiver_name, receiver_id)
    as
    select a.id as user_id, a.name as username, a.email, p.transfer_name, p.sending_time, p.amount as limitation_amount,
    c.name as receiver_name, c.id as receiver_id
    from account c, account a, transfer p where a.id = p.user_id and c.id = p.receiver_id;
    '''
    exe_db(sql_create_view_on_user_receiver_transfer_ternary)


def transfer_report(user_id):
    sql_apply_transfer_limitation = f'''
        select set_date, end_date, cast(transfer_restriction as decimal (8,2))/100 as transfer_restriction,
            cast(total_transfer as decimal (8,2))/100 as total_transfer,
            CASE WHEN transfer_restriction < total_transfer THEN 'Yes' ELSE 'No' END AS if_exceeds from
        (
        select p.set_date, (p.set_date + p.effective_days) as end_date, p.amount as transfer_restriction,
                sum(t.limitation_amount) as total_transfer
        from transfer_limitation p, time_span_transfer t
        where t.sending_time >= p.set_date and t.sending_time <= p.set_date + p.effective_days
        and p.user_id = {user_id} and t.user_id = {user_id}
        group by p.amount, p.set_date, p.effective_days
        order by p.set_date
        ) as pt;
        '''
    st.write(':memo: User\'s Spending Restriction Report')
    # preprocessing data in dataframe format
    restriction_table = query_db(sql_apply_transfer_limitation)
    if not restriction_table.empty:
        st.dataframe(
            restriction_table.style.format(subset=['transfer_restriction', 'total_transfer'], formatter='{:.2f}'))
    else:
        st.write('No Restriction Set by User')


# leaderboard of companies that has the top revenues
#Merchant： filter-> name/location
#按照followers排序，每个下拉表有具体信息，比如name,headline, location,followers, connections,about

def company_format(num):
    magnitude = 0
    while abs(num) >= 1000:
        magnitude += 1
        num /= 1000.0
    # add more suffixes if you need them
    return '%.2f%s' % (num, ['', 'K', 'M', 'G', 'T', 'P'][magnitude])


#可以改成按照收款从高到低排序
def merchant_leaderboard():
    st.sidebar.write("Filters:")
    sql_compnay_location = "SELECT distinct location FROM company ORDER BY location"
    company_name = st.sidebar.text_input("Merchant Name")
    location = st.sidebar.selectbox("Location", ["All Locations"] + query_db(sql_compnay_location)["location"].tolist())
    #sql_compnay = "SELECT c.name, c.headline, c.location, c.followers, c.connections, c.about FROM company c"
    conditions = []
    if company_name:
        conditions.append(" Lower(c.name) LIKE Lower('%{}%')".format(company_name))
    if location != "All Locations":
        conditions.append("c.location = '{}'".format(location))
    sql_metric = f"SELECT c.name, c.img, c.followers FROM company c"
    if conditions:
        sql_metric += " WHERE "
        sql_metric += " AND ".join(conditions)
    sql_metric += " ORDER BY c.followers desc;"
    col1, col2, col3, col4 = st.columns([1, 2, 10, 10])
    col1.write('## RANK')
    col2.write('## .')
    col3.write('## Merchant')
    col4.write("## Followers")
    df = query_db(sql_metric)
    for i in range(len(df)):
        col1.markdown('<p style= "font-size: 32px;">{}</p>'.format(i + 1), unsafe_allow_html=True)
        col2.image(df.iloc[i, 1], width=51)
        col3.markdown('<p style= "font-size: 32px;">{}</p>'.format(df.iloc[i, 0]), unsafe_allow_html=True)
        col4.markdown('<p style= "font-size: 32px;">{}</p>'.format(company_format(df.iloc[i, 2])),
                      unsafe_allow_html=True)



def merchant_information():
    st.sidebar.write("Filters:")
    sql_compnay_location = "SELECT distinct location FROM company ORDER BY location"
    company_name = st.sidebar.text_input("Merchant Name")
    location = st.sidebar.selectbox("Location", ["All Locations"] + query_db(sql_compnay_location)["location"].tolist())
    followers = st.sidebar.number_input(label="followers number bigger than", min_value=0, max_value=20000000000, value=0, step=1)
    connections = st.sidebar.number_input(label="connections number bigger than", min_value=0, max_value=20000000000, value=0, step=1)
    conditions = []
    if company_name:
        conditions.append(" Lower(c.name) LIKE Lower('%{}%')".format(company_name))
    if location != "All Locations":
        conditions.append("c.location = '{}'".format(location))
    if followers:
        conditions.append("c.followers > '{}'".format(followers))
    if connections:
        conditions.append("c.connections > '{}'".format(connections))
    sql_metric = f"SELECT c.name, c.img, c.followers,c.about, c.location,c.connections, c.img FROM company c"
    if conditions:
        sql_metric += " WHERE "
        sql_metric += " AND ".join(conditions)
    sql_metric += " ORDER BY c.followers desc;"
    df = query_db(sql_metric)
    for i in range(len(df)):
        my_expander = st.expander("{}".format(df.iloc[i,0]), expanded=False)
        with my_expander:
            render_merchant_page(df.iloc[i,0],)


#name,headline, location,followers, connections,about
def render_merchant_page(name):
    sql_company_info = f"SELECT * FROM company WHERE name = '{name}';"
    company_info = query_db(sql_company_info)
    #st.write("# {}".format(name))
    img = company_info['img'].values[0]
    st.image(img, width = 60)
    st.markdown(f"""
* Name:        {company_info['name'].values[0]}
* Headline:    {company_info['headline'].values[0]}
* Followers:   {company_info['followers'].values[0]}
* Connections: {company_info['connections'].values[0]}
* About:  \n
{company_info['about'].values[0]}
        """)

#Complaint: -> content/create_date/resolve, Urgency(sever1-5)/resolve/create_date/ : 下拉表
def complaint():
    st.sidebar.write("Filters:")
    sql_resolve = "SELECT distinct resolved FROM complaint order by resolved"
    sql_urgency = "SELECT distinct urgency FROM complaint order by urgency"
    sql_complaint_customer = "SELECT distinct a.name  FROM complaint c, account a where a.id = c.user_id order by a.name"
    resolved = st.sidebar.selectbox("Resolved", ["All Situations"] + query_db(sql_resolve)["resolved"].tolist())
    urgency = st.sidebar.selectbox("urgency", ["All Levels of urgency"] + query_db(sql_urgency)["urgency"].tolist())
    complaint_date = st.sidebar.date_input('Dates', value=[datetime.date(2001, 1, 1), datetime.date(2023, 12, 30)])
    if len(complaint_date)==1 or complaint_date[0]>=complaint_date[1]:
        st.write('### please select a valid date')
    else:
        start_date = complaint_date[0]
        end_date = complaint_date[1]
        complaint_customer = st.sidebar.selectbox("Complaint Customer", ["All customers"] + query_db(sql_complaint_customer)["name"].tolist())
        conditions = []
        if complaint_customer != "All customers":
            conditions.append("a.name = '{}'".format(complaint_customer))
        if resolved != "All Situations":
            conditions.append("c.resolved = '{}'".format(resolved))
        if urgency != "All Levels of urgency":
            conditions.append("c.urgency = '{}'".format(urgency))

        sql_metric = f"SELECT c.content, c.urgency, c.resolved,c.created_on,a.name FROM complaint c, account a where a.id = c.user_id and c.created_on >= '{start_date}' and c.created_on <= '{end_date}'"
        if conditions:
            #sql_metric += " WHERE "
            sql_metric += " AND " + " AND ".join(conditions)
        sql_metric += " ORDER BY c.urgency desc, c.created_on;"
        df = query_db(sql_metric)
        if df.empty:
            st.write('### No Complaint for this filter')
            #continue
        st.table(df)

    # TODO:
    #  颜色，日期选择不要报错，无data时显示。 改掉之前user page



PAGES = OrderedDict([
    ('Contact', contact),
    ("Users", users),
    ('Payments', payment),
    ('Complaint', complaint),
    ('Merchant_leaderboard', merchant_leaderboard),
    ('Merchant_information', merchant_information),
    ('Transfer', transfer),
])


def run():
    page_name = st.sidebar.selectbox("Choose a page", list(PAGES.keys()), 0)
    page = PAGES[page_name]
    st.write("# {}".format(page_name))
    page()


if __name__ == "__main__":
    run()
