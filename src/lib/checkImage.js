// Stores past URLs that failed to load. Used for a quick lookup
// and because `onerror` is not triggered in some browsers
// if the response is cached.
let errors = {};

// Check the existence of an image file at `url` by creating a
// temporary Image element. The `success` callback is called
// if the image loads correctly or the image is already complete.
// The `failure` callback is called if the image fails to load
// or has failed to load in the past.
export function checkImage (url, success, failure) {
  var img = new Image(),    // the 
      loaded = false,
      errored = false;

  // Run only once, when `loaded` is false. If `success` is a
  // function, it is called with `img` as the context.
  img.onload = function () {
    if (loaded) {
      return;
    }

    loaded = true;

    if (success && success.call) {
      return success.call(img);
    }
  };

  // Run only once, when `errored` is false. If `failure` is a
  // function, it is called with `img` as the context.
  img.onerror = function () {
    if (errored) {
      return;
    }

    errors[url] = errored = true;

    if (failure && failure.call) {
      return failure.call(img);
    }
  };

  // If `url` is in the `errors` object, trigger the `onerror`
  // callback.
  if (errors[url]) {
    img.onerror.call(img);
    return;
  }
  
  // Set the img src to trigger loading
  img.src = url;

  // If the image is already complete (i.e. cached), trigger the
  // `onload` callback.
  if (img.complete) {
    img.onload.call(img);
  }
};
