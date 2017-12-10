package nu.mine.mosher.xml.xslt;

import nu.mine.mosher.xml.SimpleXml;
import org.xml.sax.SAXParseException;

import javax.xml.transform.TransformerException;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.net.URISyntaxException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Collections;
import java.util.Map;

import static spark.Spark.*;

public class XsltServer {
    private static final Map<String, Object> FULL = Collections.singletonMap("full", true);

    private Path teidir;

    public static void main(final String... args) throws IOException {
        new XsltServer().run(args);
        System.out.flush();
        System.err.flush();
    }

    private void run(final String... args) throws IOException {
        handleArgs(args);

        staticFiles.location("/");
        staticFiles.expireTime(600);

        redirect.get("", "/");
        get("/", (req, res) -> index());

        get("/text/:xml", (req, res) -> {
            res.type("application/xml; charset=utf-8");
            return text(req.params(":xml"));
        });
        get("/text/:xml/:xslt", (req, res) -> {
            res.type("text/html; charset=utf-8");
            return text(req.params(":xml"), req.params(":xslt"));
        });
    }

    private String index() throws IOException {
        final StringBuilder s = new StringBuilder(1024);
        s.append("<!doctype html><html lang=\"en\"><head><meta charset=\"utf-8\"><title>TEI</title></head><body><ul>");

        Files.newDirectoryStream(this.teidir, path -> path.toString().endsWith(".xml")).forEach(f -> {
            final String fn = f.getFileName().toString();
            s.append("<li>");
            s.append("<small>[<a href=\"text/").append(fn).append("/teish.xslt\">formatted</a>]</small>&nbsp;");
            s.append("<small>[<a href=\"text/").append(fn).append("\">TEI</a>]</small>&nbsp;").append(fn);
            s.append("</li>");
        });

        s.append("</ul></body></html>");
        return s.toString();
    }

    private void handleArgs(final String... args) throws IOException {
        if (args.length != 1) {
            throw new IllegalArgumentException("usage: java -cp ... " + this.getClass().getName() + " directory");
        }
        final Path teidir = Paths.get(args[0]);
        if (!teidir.toFile().exists()) {
            throw new FileNotFoundException(teidir.toFile().getCanonicalPath());
        }
        this.teidir = teidir;
    }

    private String text(final String nameXml, final String nameXslt) throws SAXParseException, IOException, URISyntaxException, TransformerException {
        return getXml(nameXml).transform(getXslt(nameXslt), FULL);
    }

    private String text(final String nameXml) throws SAXParseException, IOException {
        return getXml(nameXml).toString();
    }

    private SimpleXml getXml(final String nameXml) throws SAXParseException, IOException {
        return new SimpleXml(readFrom(getLocalPath(nameXml)));
    }

    private static String getXslt(final String nameXslt) throws IOException, URISyntaxException {
        return readFrom(getResourcePath(nameXslt));
    }

    private Path getLocalPath(final String filename) throws FileNotFoundException {
        return this.teidir.resolve(filename);
    }

    private static Path getResourcePath(final String filename) throws URISyntaxException {
        return Paths.get(XsltServer.class.getResource("/" + filename).toURI());
    }

    private static String readFrom(final Path source) throws IOException {
        return String.join("\n", Files.readAllLines(source, StandardCharsets.UTF_8));
    }
}
