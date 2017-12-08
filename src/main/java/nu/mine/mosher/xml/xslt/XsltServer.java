package nu.mine.mosher.xml.xslt;

import net.sf.saxon.s9api.SaxonApiException;

import javax.xml.transform.stream.StreamSource;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

import static spark.Spark.*;

public class XsltServer {
    private final Saxon saxon = new Saxon();
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
        get("/", (req, res) -> {
            final StringBuilder s = new StringBuilder(1024);
            s.append("<!doctype html><html lang=\"en\"><head><meta charset=\"utf-8\"><title>TEI</title></head><body><ul>");

            Files.newDirectoryStream(this.teidir, path -> path.toString().endsWith(".xml")).forEach(f -> {
                final String fn = f.getFileName().toString();
                s.append("<li>");
//                s.append("<a href=\"text/").append(fn).append("/teish.xslt\">").append(fn).append("</a>");
//                s.append("&nbsp;<small>(<a href=\"text/").append(fn).append("\">TEI</a>)</small>");
                s.append("<small>[<a href=\"text/").append(fn).append("/teish.xslt\">formatted</a>]</small>&nbsp;");
                s.append("<small>[<a href=\"text/").append(fn).append("\">TEI</a>]</small>&nbsp;").append(fn);
                s.append("</li>");
            });

            s.append("</ul></body></html>");
            return s.toString();
        });

        get("/text/:xml", (req, res) -> {
            res.type("application/xml; charset=utf-8");
            return text(req.params(":xml"));
        });
        get("/text/:xml/:xslt", (req, res) -> {
            res.type("text/html; charset=utf-8");
            return text(req.params(":xml"), req.params(":xslt"));
        });
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

    private StringBuffer text(final String nameXml, final String nameXslt) throws SaxonApiException, FileNotFoundException {
        return this.saxon.xform(this.saxon.createXdoc(getLocalSource(nameXml)), this.saxon.createXformer(getResSource(nameXslt)));
    }

    private StringBuffer text(final String nameXml) throws SaxonApiException, FileNotFoundException {
        return this.saxon.form(this.saxon.createXdoc(getLocalSource(nameXml)));
    }

    private StreamSource getLocalSource(final String filename) throws FileNotFoundException {
        return new StreamSource(getLocalFile(filename));
    }

    private File getLocalFile(final String filename) throws FileNotFoundException {
        return this.teidir.resolve(filename).toFile();
    }

    private static StreamSource getResSource(final String filename) {
        return new StreamSource(getResReader(filename));
    }

    private static InputStreamReader getResReader(final String filename) {
        return new InputStreamReader(XsltServer.class.getResourceAsStream("/" + filename), StandardCharsets.UTF_8);
    }
}
