/**
* @Author: Tran Van Nhut <nhutdev>
* @Date:   2017-02-28T16:20:54+07:00
* @Email:  tranvannhut4495@gmail.com
* @Last modified by:   nhutdev
* @Last modified time: 2017-02-28T16:20:59+07:00
*/



ALTER TABLE vv.product
   ADD CONSTRAINT product_category_group_id_pkey
   FOREIGN KEY (category_group_id)
   REFERENCES vv.category_group(id);
