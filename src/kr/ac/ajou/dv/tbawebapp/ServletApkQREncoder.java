package kr.ac.ajou.dv.tbawebapp;

import com.google.zxing.BarcodeFormat;
import com.google.zxing.MultiFormatWriter;
import com.google.zxing.WriterException;
import com.google.zxing.client.j2se.MatrixToImageWriter;
import com.google.zxing.common.BitMatrix;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "ServletApkQREncoder")
public class ServletApkQREncoder extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String url = request.getParameter("url");

        // generating a QR code
        BarcodeFormat barcodeFormat = BarcodeFormat.QR_CODE;
        int width = 300;
        int height = 300;

        MultiFormatWriter barcodeWriter = new MultiFormatWriter();
        BitMatrix matrix;
        try {
            matrix = barcodeWriter.encode(url, barcodeFormat, width, height);
            response.setContentType("image/png");
            MatrixToImageWriter.writeToStream(matrix, "png", response.getOutputStream());
        } catch (WriterException e) {
            response.setContentType("text/plain");
            response.getWriter().write(e.getLocalizedMessage());
        }
    }
}
