try {
  const Trix = require("trix")

  Trix.config.blockAttributes.heading2 = {
    tagName: "h2",
    terminal: true,
    breakOnReturn: true,
    group: false
  }

  Trix.config.blockAttributes.heading3 = {
    tagName: "h3",
    terminal: true,
    breakOnReturn: true,
    group: false
  }
}

catch(err) {
  console.log('Trix failed in javascript/components/trix_bundle.js')
}
