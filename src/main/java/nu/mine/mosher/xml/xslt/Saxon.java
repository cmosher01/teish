package nu.mine.mosher.xml.xslt;

import net.sf.saxon.s9api.*;

import javax.xml.transform.Source;
import java.io.StringWriter;
import java.io.Writer;

public class Saxon {
    private final Processor processor = new Processor(false);

    public XdmNode createXdoc(final Source xml) throws SaxonApiException {
        return this.processor.newDocumentBuilder().build(xml);
    }

    public StringBuffer form(final XdmValue xml) throws SaxonApiException {
        final StringWriter sResult = new StringWriter(2048);
        this.processor.writeXdmValue(xml, createXmlSerializer(sResult));
        return sResult.getBuffer();
    }

    public Xslt30Transformer createXformer(final Source xslt) throws SaxonApiException {
        return this.processor.newXsltCompiler().compile(xslt).load30();
    }

    public StringBuffer xform(final XdmValue xml, final Xslt30Transformer xformer) throws SaxonApiException {
        final StringWriter sResult = new StringWriter(2048);
        xformer.applyTemplates(xml, createGenericSerializer(sResult));
        return sResult.getBuffer();
    }

    private Serializer createXmlSerializer(final Writer out) {
        final Serializer serializer = createGenericSerializer(out);
        serializer.setOutputProperty(Serializer.Property.METHOD, "xml");
        serializer.setOutputProperty(Serializer.Property.ENCODING, "utf-8");
        serializer.setOutputProperty(Serializer.Property.INDENT, "no");
        serializer.setOutputProperty(Serializer.Property.OMIT_XML_DECLARATION, "no");
        return serializer;
    }

    private Serializer createGenericSerializer(final Writer out) {
        return this.processor.newSerializer(out);
    }
}
