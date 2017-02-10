/*
 * @Author: toan.nguyen
 * @Date:   2016-08-04 09:45:54
 * @Last Modified by:   toan.nguyen
 * @Last Modified time: 2016-08-04 15:28:48
 */

'use strict';

use gvn

db.createCollection('cleanerActivity');
db.createCollection('cleanerActivityLog');
db.cleanerActivity.createIndex({ cleanerId: 1, unique: true });
db.cleanerActivity.createIndex({ location: "2dsphere" });
