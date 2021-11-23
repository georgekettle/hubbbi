let eventListenerAdded = false

const initReceivePostMessage = () => {
	if (!eventListenerAdded) {
		document.addEventListener("message", (event)=>{
			if (event.data && event.data.type === 'expo:safe-area-insets') {
				receiveSafeAreaInsets(event)
			}
		})
		eventListenerAdded = true
	}
}

const receiveSafeAreaInsets = (event) => {
	console.log("initReceivePostMessage")
	console.log(event)
	console.log(event.data)
	alert(event.data)
}

export { initReceivePostMessage }