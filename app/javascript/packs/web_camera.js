const videoElement = document.getElementById('webcam');
if (navigator.mediaDevices && navigator.mediaDevices.getUserMedia) {
  navigator.mediaDevices.getUserMedia({ video: true })
    .then(function (stream) {
      videoElement.srcObject = stream;
    })
    .catch(function (error) {
      console.error("Error accessing webcam: " + error);
    });
} else {
  console.error("getUserMedia not supported");
}

window.addEventListener('load', function() {
  document.getElementById('show-camera').addEventListener('click', function() {
    document.getElementById('camera-section').style.display = 'block';
    document.getElementById('form-section').style.display = 'none';
  });

  document.getElementById('show-form').addEventListener('click', function() {
    document.getElementById('camera-section').style.display = 'none';
    document.getElementById('form-section').style.display = 'block';
  });
});

const captureButton = document.getElementById('capture');
const canvasElement = document.getElementById('canvas');
const ctx = canvasElement.getContext('2d');
captureButton.addEventListener('click', () => {
  console.log('captureButton clicked');
  videoElement.pause();
  canvasElement.width = videoElement.videoWidth;
  canvasElement.height = videoElement.videoHeight;
  ctx.drawImage(videoElement, 0, 0, videoElement.videoWidth, videoElement.videoHeight);
  console.log("test");
  // 画像データを取得
  const imageData = canvasElement.toDataURL('image/png');
  // 画像データをBlob形式に変換
  const imageBlob = base64ToBlob(imageData);
  // 画像データを処理する
  sendImageDataToServer(imageBlob);
  console.log("test2");
});

function sendImageDataToServer(imageBlob) {
  const formData = new FormData();
  formData.append('image', imageBlob);
  console.log("test3");
  fetch('/smile_prices', {
    method: 'POST',
    headers: {
      'Accept': 'application/json',
      'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
    },
    body: formData
  })
  .then(response => {
    console.log('fetch called');
    if (!response.ok) {
      // If the response is not OK, throw an error.
      throw new Error(`HTTP error! status: ${response.status}`);
    }
    // Otherwise, parse the JSON as usual.
    return response.json();
  })
  .catch((error) => {
    console.error('HTTP or JSON parse error:', error);
    // Check the error message and display a user-friendly message
    if(error.message.includes('422')) {
      displayErrorMessage('送信した情報に問題があります。再度確認してから送信してください。');
    } else {
      displayErrorMessage('エラーが発生しました。ページをリロードしてみてください。');
    }
    videoElement.play(); 
    return;
  })
  .then(data => {
    console.log('Success:', data);
    if (data.redirect_url) {
      console.log('Redirecting to', data.redirect_url);
      window.location.href = data.redirect_url;
      console.log('Should have redirected by now.');
    }
  })
  .catch((error) => {
    console.error('Error processing data:', error);
    // Check the error message and display a user-friendly message
    if (error && error.error) {
      displayErrorMessage('データの処理中にエラーが発生しました。ページをリロードしてみてください。');
    } else {
      // If the error is undefined, it's likely the 'redirect_url' property was not found
      displayErrorMessage('リダイレクト先の情報が見つかりません。ページをリロードしてみてください。');
    }
    videoElement.play(); 
  });
};

function clearErrorMessage() {
  const errorMessageContainer = document.getElementById('errorMessageContainer');
  while (errorMessageContainer.firstChild) {
    errorMessageContainer.removeChild(errorMessageContainer.firstChild);
  }
};
function displayErrorMessage(message) {
  clearErrorMessage(); 
  const errorMessageContainer = document.createElement('div');
  errorMessageContainer.classList.add('alert', 'alert-warning', 'shadow-lg', 'items-center', 'mb-2');

  const errorMessageDiv = document.createElement('div');
  const errorMessageSpan = document.createElement('span');
  errorMessageSpan.textContent = message;

  errorMessageDiv.appendChild(errorMessageSpan);
  errorMessageContainer.appendChild(errorMessageDiv);

  const errorMessageArea = document.getElementById('error-message-area'); // ここを修正
  errorMessageArea.appendChild(errorMessageContainer);
};

function base64ToBlob(base64Data) {
const binaryData = atob(base64Data.split(',')[1]);
const arrayBuffer = new ArrayBuffer(binaryData.length);
const byteArray = new Uint8Array(arrayBuffer);

for (let i = 0; i < binaryData.length; i++) {
  byteArray[i] = binaryData.charCodeAt(i);
}

const blob = new Blob([arrayBuffer], { type: 'image/png' });
return blob;
};