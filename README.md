# T-Money_streamlit
需求：

红：lyq

蓝：ljh

- [ ]  Navigation:
User /merchant /complaint /contact /pay /transaction_limitation /pay_limitation
- [ ]  Search bar:
User/
- [ ]  User:  ->filter the corresponding users ->name/email/join_date/age
Age : 下拉表，年龄段（10岁为一个）
area /gender /education /profession/   ：下拉表
- [ ]  Merchant： filter-> name/join_date/stars/about
Profession/ scale/ stars/     :下拉表
- [ ]  Complaint: -> content/create_date/resolve
Urgency(sever1-5)/resolve/create_date/ : 下拉表
- [ ]  Contact -> user    (再选择user后，chat box)
User/period
- [ ]  Pay —> merchant/amount/date_time
User/period
- [ ]  transfer → user/amount/date_time
- [ ]  transaction_limitation -> transaction / total_amount / transaction_limitation / if beyond limitation
User
- [ ]  Contact_limitation   ->  user
user


#### How to dump sql schema and data:
```sql
pg_dump -U postgres t_money > dump.sql
```
