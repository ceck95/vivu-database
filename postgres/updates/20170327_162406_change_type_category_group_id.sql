/**
 * @Author: Tran Van Nhut <nhutdev>
 * @Date:   2017-03-27T16:24:06+07:00
 * @Email:  tranvannhut4495@gmail.com
 * @Last modified by:   nhutdev
 * @Last modified time: 2017-03-27T16:32:12+07:00
 */

ALTER TABLE vv.category ALTER COLUMN category_group_id TYPE integer USING (category_group_id::integer);
