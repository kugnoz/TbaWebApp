package kr.ac.ajou.dv.tbawebapp;

import com.google.zxing.BarcodeFormat;
import com.google.zxing.MultiFormatWriter;
import com.google.zxing.WriterException;
import com.google.zxing.client.j2se.MatrixToImageWriter;
import com.google.zxing.common.BitMatrix;
import org.apache.commons.codec.binary.Base64;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "ServletTbaQREncoder")
public class ServletTbaQREncoder extends HttpServlet {
    private static final String SEPARATOR = "+";

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        StringBuffer sb = new StringBuffer();

        String mode = request.getParameter("mode");
        sb.append(mode.toUpperCase());
        sb.append(SEPARATOR);

        // adding host info
        sb.append(HostInfo.getWebAppName());
        sb.append(SEPARATOR);

        // adding public key info
        KeyBank bank = KeyBank.getInstance();

        sb.append(Base64.encodeBase64URLSafeString(bank.getPubKey().getEncoded()));
        sb.append(SEPARATOR);

        // adding nonce
        sb.append(request.getParameter("n"));

        String str = sb.toString();

        // generating a QR code
        BarcodeFormat barcodeFormat = BarcodeFormat.QR_CODE;
        int width = 400;
        int height = 400;

        MultiFormatWriter barcodeWriter = new MultiFormatWriter();
        try {
            BitMatrix matrix = barcodeWriter.encode(str, barcodeFormat, width, height);
            response.setContentType("image/png");
            MatrixToImageWriter.writeToStream(matrix, "png", response.getOutputStream());
        } catch (WriterException e) {
            response.setContentType("text/plain");
            response.getWriter().write(e.getLocalizedMessage());
        }
    }
}
