/*
 * Package : Sporran
 * Author : S. Hamblett <steve.hamblett@linux.com>
 * Date   : 05/02/2014
 * Copyright :  S.Hamblett@OSCF
 */

library sporran_test;

import 'dart:async';
import 'dart:html';

import '../lib/sporran.dart';
import 'package:json_object/json_object.dart';
import 'package:unittest/unittest.dart';  
import 'package:unittest/html_config.dart';
import 'sporran_test_config.dart';

main() {  
  
  useHtmlConfiguration();
  
  
  /* Group 1 - Environment tests */
  group("1. Environment Tests - ", () {
    
    String status = "online";
    
    test("Online/Offline", () {  
      
      window.onOffline.listen((e){
        
        expect(status, "offline");
        /* Because we aren't really offline */
        expect(window.navigator.onLine, isTrue);
        
      });
      
      window.onOnline.listen((e){
        
        expect(status, "online");
        expect(window.navigator.onLine, isTrue);
        
      });
      
      status = "offline";
      var e = new Event.eventType('Event', 'offline');
      window.dispatchEvent(e);
      status = "online";
      e = new Event.eventType('Event', 'online');
      window.dispatchEvent(e);
      
      
    });  
    
  });
  
  /* Group 2 - Sporran constructor tests */
  group("2. Constructor Tests - ", () {
    
    
    test("Construction New Database ", () {  
      
      void wrapper() {
        
        Sporran sporran = new Sporran(databaseName,
            hostName,
            port,
            scheme,
            userName,
            userPassword);
        
        expect(sporran, isNotNull);
        expect(sporran.dbName, databaseName);
        
      };
      

      expect(wrapper, returnsNormally);
     
      
    });
    
    test("Construction Existing Database ", () {  
      
      void wrapper() {
        
        
        Sporran sporran = new Sporran(databaseName,
            hostName,
            port,
            scheme,
            userName,
            userPassword);
        
        expect(sporran, isNotNull);
        expect(sporran.dbName, databaseName);
        
      };
      

      expect(wrapper, returnsNormally);
     
      
    });
    
    test("Construction Invalid Database ", () {  
      
      void wrapper() {
        
        Sporran sporran = new Sporran('freddy',
            hostName,
            port,
            scheme,
            userName,
            'notreal');
        
        expect(sporran, isNotNull); 
          
        };
     
      expect(wrapper, returnsNormally);
     
      
    });
   
  });    
  
  /* Group 3 - Sporran document put/get tests */
  solo_group("2. Document Put/Get Tests - ", () {
    
    Sporran sporran;
    
    String docIdPutOnline = "putOnline";
    String docIdPutOffline = "putOffline";
    JsonObject onlineDoc = new JsonObject();
    JsonObject offlineDoc = new JsonObject();
    
    test("Create and Open Sporran", () { 
      
    
    var wrapper = expectAsync0(() {
      
      expect(sporran.dbName, databaseName);
      
    });
    
    sporran = new Sporran(databaseName,
        hostName,
        port,
        scheme,
        userName,
        userPassword);
    
    
    /* Wait for the database to open, only need to do this once */
    Timer wait = new Timer(new Duration(milliseconds:500),wrapper);
      
  
    });
    
   test("Put Document Online New", () { 
      
     
      var wrapper = expectAsync0(() {
                    
          JsonObject res = sporran.completionResponse;
          expect(res.ok, isTrue);
          expect(res.operation, Sporran.PUT);         
        
      });
      
      sporran.online = true;
      sporran.clientCompleter = wrapper;
      onlineDoc.name = "Online";
      sporran.put(docIdPutOnline, 
                  onlineDoc);
                                
      
    });
   
   test("Put Document Online Conflict", () { 
     
     
     var wrapper = expectAsync0(() {
       
       JsonObject res = sporran.completionResponse;
       expect(res.errorCode, 409);
       expect(res.errorText, 'conflict');
       expect(res.operation, Sporran.PUT);  
      
       
     });
     
     sporran.online = true;
     sporran.clientCompleter = wrapper;
     onlineDoc.name = "Online";
     sporran.put(docIdPutOnline, 
                 onlineDoc);                                   
     
   });
   
   test("Put Document Offline New", () { 
     
     sporran.online = false;
     sporran.clientCompleter = null;
     offlineDoc.name = "Offline";
     sporran.put(docIdPutOffline, 
                 offlineDoc);
     
     
   });
    
  });
  
}