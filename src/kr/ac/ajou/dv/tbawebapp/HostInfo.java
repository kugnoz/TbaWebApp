package kr.ac.ajou.dv.tbawebapp;

import java.net.InetAddress;
import java.net.NetworkInterface;
import java.net.SocketException;
import java.net.UnknownHostException;
import java.util.Enumeration;

public class HostInfo {
    public static final String MESSAGE_QUEUE_HOSTNAME = "dv.ajou.ac.kr";
    private static final String HTTP = "http://";
    private static final String LOCAL_PORT = ":8080";
    private static final String WEB_PORT = ":80";
    private static final String WEB_APP_NAME = "/tbaWebApp";

    private static String HOSTNAME = null;
    private static boolean local = false;

    private static String getHostName() {
        if (HOSTNAME == null) {
            try {
                HOSTNAME = InetAddress.getLocalHost().getHostName();
                if (HOSTNAME.equals("sunnibo-PC")) {
                    for (Enumeration<NetworkInterface> en = NetworkInterface
                            .getNetworkInterfaces(); en.hasMoreElements(); ) {
                        NetworkInterface intf = en.nextElement();
                        for (Enumeration<InetAddress> enumIpAddr = intf
                                .getInetAddresses(); enumIpAddr.hasMoreElements(); ) {
                            InetAddress inetAddress = enumIpAddr.nextElement();
                            if (!inetAddress.isLoopbackAddress() && intf.getDisplayName().startsWith("Intel")) {
                                String ipaddr = inetAddress.getHostAddress().toString();
                                if (ipaddr.startsWith("1")) {
                                    HOSTNAME = ipaddr;
                                    local = true;
                                }
                            }
                        }
                    }
                } else {
                    local = false;
                }
            } catch (UnknownHostException e) {
                HOSTNAME = "";
            } catch (SocketException e) {
                HOSTNAME = "";
            }
        }
        return HOSTNAME;
    }

    public static String getWebAppName() {
        String hostname = getHostName();
        if (local) {
            return HTTP + hostname + LOCAL_PORT;
        }
        return HTTP + hostname + WEB_PORT + WEB_APP_NAME;
    }
}
