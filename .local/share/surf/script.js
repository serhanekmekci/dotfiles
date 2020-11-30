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
(function () {
	var urls = {}
	var feeds = [].slice.call(document.querySelectorAll(
		"link[href][rel~=alternate][type$=xml]," +
		"   a[href][rel~=alternate][type$=xml]"))
		.map(function (el) {
			return {
				href: el.href,
				title: el.title || document.title,
				type: /atom/i.test(el.type) ? 'Atom' : 'RSS'
			};
		}).filter(function (feed) {
			if (urls[feed.href]) return false
			return urls[feed.href] = true
		});
	if (!feeds.length) return;
	var container = document.createElement('div');
	container.style.position = 'fixed';
	container.style.bottom = 0;
	container.style.right = 0;
	container.style.zIndex = 10000;
	document.body.appendChild(container);
	var feedList = document.createElement('div');
	feedList.style.display = 'none';
	feedList.style.backgroundColor = '#000000';
	feedList.style.border = '2px solid #ffffff';
	feedList.style.borderStyle = 'solid solid none';
	feedList.style.padding = '2px 4px';
	container.appendChild(feedList);
	feeds.forEach(function (feed) {
		var a = document.createElement('a');
		a.href = feed.href;
		a.style.display = 'block';
		a.style.color = 'white';
		var title = feed.title;
		if (title.indexOf(feed.type) == -1)
			title += ' (' + feed.type + ')';
		a.appendChild(document.createTextNode(title));
		feedList.appendChild(a);
	});
	var toggleLink = document.createElement('a');
	toggleLink.href = '';
	toggleLink.style.display = 'inline-block';
	toggleLink.style.paddingRight = '3px';
	toggleLink.style.verticalAlign = 'bottom';
	toggleLink.addEventListener("click", toggleFeedList, true);
	container.appendChild(toggleLink);
	var img = new Image();
	img.style.padding = '4px';
	img.style.verticalAlign = 'bottom';
	img.src = 'data:image/gif;base64,' +
		'R0lGODlhDAAMAPUzAPJoJvJqKvNtLfNuL/NvMfNwMvNyNPNzNvN0OPN1OfN3O/R4' +
		'PfR5P/R6QPR7QvR+RvR/R/SASfSBS/SDTPWETvWFUPWGUvWJVfWLWfWMWvWNXPaW' +
		'aPaYbPaabfebb/eccfeedPehePemf/ingPiphPiqhviui/ivjfiwjviykPm6nPm+' +
		'ofzh1P3k2f3n3P7u5/7v6P738/749f///wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA' +
		'AAAAAAAAAAAAAAAAACH5BAEAADQALAAAAAAMAAwAAAZ6QFqB4YBAJBLKZCEsbCDE' +
		'I2WqQCBms9fqkqRIJg7EZ+WawTxeSAS6AklIMhknwjA6sC/SR/aSKBwSEBcpLzMk' +
		'IjMoBwwTECEoGTAvDi8uBAhKMokmMxwqMwIIFhQsMRoZMyeIFgILFoEMCAcEAgEA' +
		'BDQKRhAOsbICNEEAOw==';
	toggleLink.appendChild(img);
	if (feeds.length > 1) {
		toggleLink.appendChild(document.createTextNode(feeds.length));
	}
	function toggleFeedList(e) {
		e.preventDefault();
		feedList.style.display = (feedList.style.display == 'none') ?
			'inline-block' : 'none';
	}
})();
