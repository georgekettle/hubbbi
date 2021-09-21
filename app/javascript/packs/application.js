// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import "@hotwired/turbo-rails"
import * as ActiveStorage from "@rails/activestorage"
import "channels"
import 'controllers'

Rails.start()
ActiveStorage.start()

// External imports
import "bootstrap";

// Internal imports, e.g:
// import { initLightbox } from '../components/init_lightbox';

document.addEventListener('turbo:load', () => {
  // Call your functions here, e.g:
  // initLightbox()
  console.log('turbo')
});

import "stylesheets/application"
require("dragula")
