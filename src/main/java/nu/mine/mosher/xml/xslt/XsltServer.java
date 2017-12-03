package nu.mine.mosher.xml.xslt;

import net.sf.saxon.s9api.SaxonApiException;

import javax.xml.transform.stream.StreamSource;
import java.io.IOException;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.nio.file.Paths;

import static spark.Spark.*;

public class XsltServer {
    private final Saxon saxon = new Saxon();

    public static void main(final String... args) throws IOException {
        new XsltServer().run();
        System.out.flush();
        System.err.flush();
    }

    private void run() throws IOException {
        staticFiles.location("/public");
        staticFiles.expireTime(600);

        redirect.get("", "/");
        redirect.get("/", "/index.html");

        get("/text/:xml", (req, res) -> {
            res.type("application/xml; charset=utf-8");
            return text(req.params(":xml"));
        });
        get("/text/:xml/:xslt", (req, res) -> {
            res.type("text/html; charset=utf-8");
            return text(req.params(":xml"), req.params(":xslt"));
        });
    }

    private StringBuffer text(final String nameXml, final String nameXslt) throws SaxonApiException {
        return this.saxon.xform(this.saxon.createXdoc(getPrivateSource(nameXml)), this.saxon.createXformer(getPrivateSource(nameXslt)));
    }

    private StringBuffer text(final String nameXml) throws SaxonApiException {
        return this.saxon.form(this.saxon.createXdoc(getPrivateSource(nameXml)));
    }

    private static StreamSource getPrivateSource(final String filename) {
        return new StreamSource(getPrivateReader(filename));
    }

    private static InputStreamReader getPrivateReader(final String filename) {
        return new InputStreamReader(XsltServer.class.getResourceAsStream("/private/"+filename), StandardCharsets.UTF_8);
    }
}
