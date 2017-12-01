function main() {
    derefAttr("ref", addFirstChild);
    derefAttr("corresp", addFirstChild);
    derefAttr("copyOf", replaceElement);
    dates();
}

function derefAttr(attr, fn) {
    document.querySelectorAll("["+attr+"]").forEach(dst => {
        const src = document.querySelector(dst.getAttribute(attr));
        if (!src) {
            console.error("Error trying to dereference"+dst.getAttribute(attr)+" in:");
            console.error(dst);
            return;
        }
        fn(dst, src);
    });
}

function addFirstChild(dst, src) {
    dst.insertAdjacentElement("afterBegin", src.cloneNode(true));
}

function replaceElement(dst, src) {
    dst.parentNode.replaceChild(src.cloneNode(true), dst);
}

function dates() {
    document.querySelectorAll("date").forEach(d => {
        var t = d.getAttribute("when");
        if (!t) {
            t = d.getAttribute("when-custom");
            const m = d.getAttribute("datingMethod");
            if (m && t) {
                t += " ("+m+")";
            }
        }
        if (t) {
            addLabel(d, t);
        }
    });
}

function addLabel(dst, label) {
    const span = document.createElement("span");
    span.textContent = label;
    addFirstChild(dst, span);
}
