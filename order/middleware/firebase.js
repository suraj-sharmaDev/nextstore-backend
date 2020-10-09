var admin = require("firebase-admin");

var serviceAccount = require("../config/nextstore-firebase.json");

admin.initializeApp({
	credential: admin.credential.cert(serviceAccount),
	databaseURL: "https://nextstore-fb30e.firebaseio.com"
});

var options = {
	priority: "normal",
	timeToLive: 60 * 60  //1 hour validity
};

const createPayload = (data) => {
	var payload = {};
	switch (data.type) {
		case 'new_order':
			payload = {
				notification: {
					title: "New Order",
					body: "You have received a new order!",
					sound: "notif.mp3"
				},
				data: {
					type: data.type,
					orderId: data.orderId.toString()
				}
			};
			break;
		case 'accept_order':
			payload = {
				notification: {
					title: "Order Accepted",
					body: "You order has been accepted!",
					sound: "notif.mp3"
				},
				data: {
					type: data.type,
					orderId: data.orderId.toString()
				}
			};
			break;
		case 'complete_order':
			payload = {
				notification: {
					title: "Order Delivered",
					body: "You order has been delivered!",
					sound: "notif.mp3"
				},
				data: {
					type: data.type,
					orderId: data.orderId.toString()
				}
			};
			break;
		case 'reject_order':
			payload = {
				notification: {
					title: "Order Rejected",
					body: "You order has been rejected!",
					sound: "notif.mp3"
				},
				data: {
					type: data.type,
					orderId: data.orderId.toString()
				}
			};
			break;
		case 'new_quote':
			payload = {
				notification: {
					title: "New Order",
					body: "You have received a new order!",
					sound: "notif.mp3"
				},
				data: {
					type: data.type,
				}
			};
			break;
		case 'bidded_quote':
			payload = {
				notification: {
					title: "Notification",
					body: "You requirement has been bidded! Please check it.",
					sound: "notif.mp3"
				},
				data: {
					type: data.type,
				}
			};
			break;
		case 'bid_rejected':
			payload = {
				notification: {
					title: "Extremely Sorry!",
					body: "We were unable to fulfill your requirement!",
					sound: "notif.mp3"
				},
				data: {
					type: data.type,
				}
			};
			break;
		case 'bid_accepted':
			payload = {
				notification: {
					title: "Accepted!",
					body: "Your quote has been accepted! Please proceed further steps!",
					sound: "notif.mp3"
				},
				data: {
					type: data.type,
				}
			};
			break;
		case 'quote_completed':
			payload = {
				notification: {
					title: "Completed!",
					body: "Your quote has been delivered",
					sound: "notif.mp3"
				},
				data: {
					type: data.type,
				}
			};
			break;
		default:
			payload = {
				notification: {
					title: "New notification",
					body: "You have received a new notification!",
					sound: "notif.mp3"
				}
			};
			break;
	}
	return payload;
}

const sendMessage = (data) => {
	var error = true;
	admin.messaging().sendToDevice(data.fcmToken, createPayload(data), options)
		.then(function (response) {
			error = false;
			// console.log("Successfully sent message:", response);
		})
		.catch(function (error) {
			console.log("Error sending message:", error);
		});
	return error;
}
module.exports = sendMessage;