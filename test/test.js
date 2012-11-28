var http = require("http");
var https = require("https");
var querystring = require('querystring');
var util = require("util");
var assert = require("assert");
var xml2js = require('xml2js');
var should = require('should');

var username = 'dba';
var password = 'sql';
var setup = {
        host: 'localhost',
        port: 3033    
}

var auth = 'Basic ' + new Buffer(username + ':' + password).toString('base64');

    
function extend (a, b) { for (var x in b) a[x] = b[x]; }

function getXML(sql, callback){
    var postData = querystring.stringify({
        'sql' : sql
    }); 

    var options = { 
        path: '/saq-remote',
        method: 'POST', 
        headers: {
            'Content-Type': 'application/xml',
            'Authorization':auth,
            'Content-Length': postData.length
        }
    };

    extend(options,setup);
    var prot = options.port == 443 ? https : http;
    var req = prot.request(options, function(res){

        var output = '';
        res.setEncoding('utf8');

        res.on('data', function (chunk) {
            output += chunk;
        });

        res.on('end', function(){ 
            var parser = new xml2js.Parser({
				'mergeAttrs':true
			});    
			parser.parseString(output, function (err, result) {
                var data = null;
                try{
                    data = {
                        data : result.root.data[0].row,
                        meta : result.root.meta[0].row 
                    }
                } catch(e){

                } finally {
                    callback(res.statusCode, new SAQRecordSet(data.meta, data.data));
                }
			});
			
        }); 

        req.on('error', function(err) {
	        throw err
	    });
    });
    
    // post the data
    req.write(postData);
    req.end();
};

function SAQRecordSet(meta, data) {
    var _data = data;
    var _meta = meta;
    
    this.meta = function (id) { // can be colName (string) or ColIndex (integer)
        var _prop = "COL_NAME";
        if(typeof id === "number"){
                _prop = "COL_ID";
                id = id.toString();
        }

        for (var i = 0; i < _meta.length; i++) {
            if (_meta[i][_prop] == id){
                return _meta[i];
            }
        };
    };


    this.data = function (rowIndex, colName) { 
         if (typeof colName === "undefined"){ 
            return _data[rowIndex];
        } else {  
            return _data[rowIndex][colName];
        }        
    }

    return this;
}



var recordSet = null;
var sql = "select * from systable where table_name = 'SAQ_DESCRIBE_FOREIGNKEY'"

    describe('Sql Anywhere Web Service', function(){
      describe('response', function(){
        it('should equal 200', function(done){
        	getXML(sql, function (statusCode, res) {
                assert(res!==null);
                statusCode.should.equal(200); 
                recordSet = res
                done(); 
        	});
        });
      });
    });

    describe('Response', function(){
      describe('SAQRecordSet', function(){ 
        it('should get correct data', function(){ 
            recordSet.data(0).should.have.property('table_type');
            recordSet.data(0,"table_type").should.equal('VIEW'); 
            recordSet.data(0).should.have.property('table_name'); 
            recordSet.data(0,"table_name").should.equal('SAQ_DESCRIBE_FOREIGNKEY'); 
        });

        it('should get correct meta data', function(){
            var meta1 = recordSet.meta(0);
            var meta2 = recordSet.meta("ID");
            meta1.should.have.property('COL_NAME'); 
            meta1.COL_NAME.should.equal("ID");
            meta1.should.equal(meta2);
        }); 
      });
    });
