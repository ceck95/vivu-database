/**
* @Author: Tran Van Nhut <nhutdev>
* @Date:   2017-02-26T21:10:14+07:00
* @Email:  tranvannhut4495@gmail.com
* @Last modified by:   nhutdev
* @Last modified time: 2017-02-26T21:12:20+07:00
*/



ALTER TABLE vv.category_group DROP COLUMN category_id RESTRICT;
ALTER TABLE vv.category ADD COLUMN category_id text;
