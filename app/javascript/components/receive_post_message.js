let eventListenerAdded = false
let spacerEventListenerAdded = false

const initReceivePostMessage = () => {
	if (!eventListenerAdded) {
		window.addEventListener("message", (event)=>{
			const data = JSON.parse(event.data)
			if (data && data["type"] === 'expo:safe-area-insets') {
				receiveSafeAreaInsets(data)
			}
		})
		eventListenerAdded = true
	}
}

const receiveSafeAreaInsets = (data) => {
	if (!spacerEventListenerAdded) {
		document.addEventListener('turbo:render', (event) => {
			document.querySelectorAll('#native-spacer__top').forEach((spacer) => {
				spacer.style.height = `${data.insets.top}px`
			})
		})
		spacerEventListenerAdded = true
	}
}

export { initReceivePostMessage }