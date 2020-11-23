/* keyboard buttons for surf */
/* Christian hahn <ch radamanthys de> wrote the original code */

function
keyboardButtons()
{
    const modKey      = "Alt"; /* used to initiate keyboardButtons mode */
    const escKey      = "Escape"; /* used to escape keyboardButtons mode (you can also release alt) */
    const labelStyle  = `
        box-sizing: border-box;
        position: absolute;
        display: inline;
        width: auto;
        height: auto;
        margin: 0;
        z-index: 99999;

        padding: 2px;
        border: 1px solid white;
        border-radius: 0;

        color: white;
        font-size: 12px;
        font-weight: normal;
        font-family: sans-serif;
        font-decoration: none;
        text-transform: none;
    `;
    const normalColor    = "black";
    const highlightColor = "white";

    var labels     = {};
    var input      = "";

    function
    updateLabelColor()
    {
        for (let id in labels) {
            if (input && id.startsWith(input)) labels[id].elem.style.backgroundColor = highlightColor;
            else                               labels[id].elem.style.backgroundColor = normalColor;
        }
    }

    /* by default, this function chooses some sequence of letters, change it to what you like */
    function
    numberToLabel(n)
    {
        ++n;
        const alphabet = "abçdefgğimnoöpqsştüvxyz";
        /* r is removed as it reloads keyboardButtons */

        var str = "";
        for (;n; n = Math.floor(n/alphabet.length)) {
            str += alphabet[n%alphabet.length];
        }
        return str;
    }

    function
    Label(button, text)
    {
        this.button = button;

        this.elem = document.createElement("span");
        this.elem.innerHTML = text;
        this.elem.style = labelStyle;
        this.elem.style.visibility = "hidden";
        const pos = this.button.getBoundingClientRect();
        this.elem.style.left = pos.left + scrollX + "px";
        this.elem.style.top  = pos.top  + scrollY + "px";
        document.body.appendChild(this.elem);
    }

    function
    createLabels()
    {
        for (let id in labels) labels[id].elem.parentNode.removeChild(labels[id].elem);
        labels = {};

        var buttons = Array.from(document.getElementsByTagName("a"))
              .concat(Array.from(document.getElementsByTagName("button")))
              .concat(Array.from(document.getElementsByTagName("input")));
        for (let i = 0; i < buttons.length; i++) {
            const text = numberToLabel(i);
            labels[text] = new Label(buttons[i], text);
        }
        updateLabelColor();
    }

    /* main */
    createLabels();
    /* set key handlers */
    addEventListener("keydown", function (e) {
        if (e.key === modKey) {
            input = "";
            for (let id in labels) labels[id].elem.style.visibility = "visible";
            updateLabelColor();
        } else if (e.getModifierState(modKey)) {
            if (e.key === escKey || e.key === 'c') {
                if (e.key === 'c') createLabels(); /* reload labels */
                input = "";
                for (let id in labels) labels[id].elem.style.visibility = "hidden";
            } else if (e.key.length === 1) {
                input += e.key;
            }
            updateLabelColor();
        }
    });
    addEventListener("keyup", function (e) {
        if (e.key === modKey) {
            if (labels[input] !== undefined) {
                labels[input].button.focus();
                labels[input].button.click();
            }
            input = "";
            for (let id in labels) labels[id].elem.style.visibility = "hidden";
        }
    });
}

if (document.readyState === "complete") keyboardButtons();
else document.addEventListener("readystatechange", function (e) {
    if (e.target.readyState === "complete") keyboardButtons();
});
