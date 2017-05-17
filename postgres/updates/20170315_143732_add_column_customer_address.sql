/**
* @Author: Tran Van Nhut <root>
* @Date:   2017-03-15T14:37:33+07:00
* @Email:  tranvannhut4495@gmail.com
* @Last modified by:   root
* @Last modified time: 2017-03-15T14:45:53+07:00
*/

ALTER TABLE vv.customer_address ADD COLUMN province text;
ALTER TABLE vv.customer_address ADD COLUMN district text;
ALTER TABLE vv.customer_address ADD COLUMN ward text;
ALTER TABLE vv.customer_address DROP COLUMN city;
ALTER TABLE vv.customer_address DROP COLUMN state;
