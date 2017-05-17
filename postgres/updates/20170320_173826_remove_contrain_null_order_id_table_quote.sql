/**
 * @Author: Tran Van Nhut <nhutdev>
 * @Date:   2017-03-20T17:38:26+07:00
 * @Email:  tranvannhut4495@gmail.com
 * @Last modified by:   nhutdev
 * @Last modified time: 2017-03-20T17:41:33+07:00
 */



 ALTER TABLE vv.quote
    ADD CONSTRAINT quote_sales_order_frk
    FOREIGN KEY (order_id)
    REFERENCES vv.sales_order(id);
 ALTER TABLE vv.quote ALTER order_id DROP NOT NULL;
