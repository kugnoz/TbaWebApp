package kr.ac.ajou.dv.tbawebapp;

import com.mongodb.DB;
import com.mongodb.DBCollection;
import com.mongodb.Mongo;

import java.net.UnknownHostException;


public class DbHelper {
    private static final String DB_HOSTNAME = "dv.ajou.ac.kr";
    private static final String DATABASE_NAME = "tba";
    public static final String COLL_SERVER_KEYS = "keys";
    public static final String COLL_PASSWORD_ID = "pwid";
    public static final String COLL_TBA_ID = "tba_id";
    public static final String COLL_TBA_SESSION = "tba_session";

    private static final DbHelper instance = new DbHelper();

    private DB db;

    private DbHelper() {
        try {
            Mongo m = new Mongo(DB_HOSTNAME);
            db = m.getDB(DATABASE_NAME);
        } catch (UnknownHostException e) {
            db = null;
        }
    }

    public static DbHelper getInstance() {
        return instance;
    }

    public DBCollection getCollection(String collection) {
        if (db == null) {
            return null;
        }
        return db.getCollection(collection);
    }
}
