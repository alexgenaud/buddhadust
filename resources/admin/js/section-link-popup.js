document.addEventListener("DOMContentLoaded", function () {
  const configEl = document.getElementById("sutta-metadata");
  if (!configEl) return;

  const config = JSON.parse(configEl.textContent || "{}");
  if (!config.translation || !config.title) return;

  // Pre-parse range strings into sets
  config.translation.forEach((tr) => {
    if (tr.range) {
      tr._rangeSet = new Set();
      tr.range.split(",").forEach((part) => {
        if (part.includes("-")) {
          const [start, end] = part.split("-").map(Number);
          for (let i = start; i <= end; i++) tr._rangeSet.add(i);
        } else {
          tr._rangeSet.add(Number(part));
        }
      });
    }
  });

  const popup = document.createElement("div");
  Object.assign(popup.style, {
    position: "absolute",
    background: "#fefefe",
    border: "1px solid #888",
    padding: "0.5em",
    zIndex: 9999,
    boxShadow: "0 2px 6px rgba(0,0,0,0.2)",
    display: "none",
  });
  document.body.appendChild(popup);

  let hideTimer = null;

  const sleep = (ms) => new Promise((r) => setTimeout(r, ms));

  function findNearestAvailablePara(rangeSet, paraNum) {
    console.log("findNearest");
    if (!rangeSet || rangeSet.has(paraNum)) return paraNum;

    // Try previous
    for (let i = paraNum - 1; i >= 1; i--) {
      if (rangeSet.has(i)) {
        console.log("findNearest found " + i);
        sleep(200);
        return i;
      }
    }
    // Try next
    for (let i = paraNum + 1; i <= 9999; i++) {
      if (rangeSet.has(i)) {
        console.log("findNearest found " + i);
        sleep(200);
        return i;
      }
    }
    console.log("findNearest return null");
    return null;
  }

  function showPopup(event, markerId) {
    clearTimeout(hideTimer);
    const paraNum = Number(markerId.slice(1));

    const rect = event.target.getBoundingClientRect();
    const links = config.translation
      .map((tr) => {
        let href = tr.relink;

        if (tr.range) {
          const target = findNearestAvailablePara(tr._rangeSet, paraNum);
          if (target !== null) href += `#p${target}`;
        } else {
          // Assume complete coverage
          href += `#${markerId}`;
        }

        return `<div><a href="${href}" target="_blank">${tr.author}</a></div>`;
      })
      .join("");

    popup.innerHTML = `
      <div><strong>${config.title}</strong></div>
      <div>Marker: ${markerId}</div>
      ${links}
    `;
    popup.style.left = `${rect.left + window.scrollX + 10}px`;
    popup.style.top = `${rect.bottom + window.scrollY + 5}px`;
    popup.style.display = "block";
  }

  function hidePopup() {
    hideTimer = setTimeout(() => {
      popup.style.display = "none";
    }, 500);
  }

  document.querySelectorAll('[id^="p"]').forEach((elem) => {
    if (!/^\d+$/.test(elem.id.slice(1))) return;
    elem.style.cursor = "pointer";
    elem.addEventListener("click", (e) => showPopup(e, elem.id));
    elem.addEventListener("mouseleave", hidePopup);
  });

  popup.addEventListener("mouseenter", () => clearTimeout(hideTimer));
  popup.addEventListener("mouseleave", hidePopup);
});
