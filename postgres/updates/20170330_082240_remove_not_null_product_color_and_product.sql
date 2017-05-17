/**
 * @Author: Tran Van Nhut <nhutdev>
 * @Date:   2017-03-30T08:22:40+07:00
 * @Email:  tranvannhut4495@gmail.com
 * @Last modified by:   nhutdev
 * @Last modified time: 2017-03-30T08:25:52+07:00
 */



 ALTER TABLE vv.product ALTER image_path DROP NOT NULL;
 ALTER TABLE vv.product_color ALTER refer_product_image_path DROP NOT NULL;
 ALTER TABLE vv.product_color ALTER color_name DROP NOT NULL;
