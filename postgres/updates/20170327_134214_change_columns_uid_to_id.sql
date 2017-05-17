/**
 * @Author: Tran Van Nhut <nhutdev>
 * @Date:   2017-03-27T13:42:14+07:00
 * @Email:  tranvannhut4495@gmail.com
 * @Last modified by:   nhutdev
 * @Last modified time: 2017-03-27T13:44:08+07:00
 */



ALTER TABLE adminuser.user RENAME uid TO id;
ALTER TABLE adminuser.role RENAME uid TO id;
ALTER TABLE adminuser.role_right RENAME uid TO id;
