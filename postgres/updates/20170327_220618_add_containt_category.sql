/**
 * @Author: Tran Van Nhut <nhutdev>
 * @Date:   2017-03-27T22:06:18+07:00
 * @Email:  tranvannhut4495@gmail.com
 * @Last modified by:   nhutdev
 * @Last modified time: 2017-03-27T22:07:00+07:00
 */



 ALTER TABLE vv.category
    ADD CONSTRAINT category_category_group_id_pkey
    FOREIGN KEY (category_group_id)
    REFERENCES vv.category_group(id);
