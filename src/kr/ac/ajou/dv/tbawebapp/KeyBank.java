package kr.ac.ajou.dv.tbawebapp;

import com.mongodb.BasicDBObject;
import com.mongodb.DBCollection;
import com.mongodb.DBCursor;
import com.mongodb.DBObject;
import kr.ac.ajou.dv.tbalib.crypto.CryptoConstants;

import java.security.*;
import java.security.interfaces.RSAPrivateKey;
import java.security.interfaces.RSAPublicKey;
import java.security.spec.InvalidKeySpecException;
import java.security.spec.PKCS8EncodedKeySpec;
import java.security.spec.X509EncodedKeySpec;
import java.util.Date;

public class KeyBank {
    private static final KeyBank single = new KeyBank();

    private RSAPublicKey pubKey;
    private RSAPrivateKey privKey;

    private KeyBank() {
        DbHelper db = DbHelper.getInstance();
        DBCollection coll = db.getCollection(DbHelper.COLL_SERVER_KEYS);
        DBCursor cur = coll.find().sort(new BasicDBObject("timestamp", -1));

        if (cur.hasNext()) { // There is a key.
            DBObject obj = cur.next();
            byte[] publicKeyEncoded = (byte[]) obj.get("public");
            byte[] privateKeyEncoded = (byte[]) obj.get("private");

            KeyFactory keyFactory;
            try {
                keyFactory = KeyFactory.getInstance("RSA");
                X509EncodedKeySpec publicKeySpec = new X509EncodedKeySpec(publicKeyEncoded);
                pubKey = (RSAPublicKey) keyFactory.generatePublic(publicKeySpec);
                PKCS8EncodedKeySpec privateKeySpec = new PKCS8EncodedKeySpec(privateKeyEncoded);
                privKey = (RSAPrivateKey) keyFactory.generatePrivate(privateKeySpec);

            } catch (NoSuchAlgorithmException e) {
                pubKey = null;
                privKey = null;
                e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
            } catch (InvalidKeySpecException e) {
                pubKey = null;
                privKey = null;
                e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
            }
        } else { // No keys in DB
            try {
                KeyPairGenerator keyGen = KeyPairGenerator.getInstance("RSA");
                keyGen.initialize(CryptoConstants.PUBLIC_KEY_BITS, new SecureRandom());
                KeyPair pair = keyGen.generateKeyPair();
                pubKey = (RSAPublicKey) pair.getPublic();
                privKey = (RSAPrivateKey) pair.getPrivate();

                BasicDBObject bson = new BasicDBObject();
                bson.put("timestamp", new Date());
                bson.put("public", pubKey.getEncoded());
                bson.put("private", privKey.getEncoded());

                coll.insert(bson);

            } catch (NoSuchAlgorithmException e) {
                pubKey = null;
                privKey = null;
                e.printStackTrace();
            }
        }
    }

    public static KeyBank getInstance() {
        return single;
    }

    public RSAPublicKey getPubKey() {
        return pubKey;
    }

    public RSAPrivateKey getPrivKey() {
        return privKey;
    }
}
