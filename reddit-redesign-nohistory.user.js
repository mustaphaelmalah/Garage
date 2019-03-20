// ==UserScript==
// @name         Reddit Redesign No History
// @namespace    https://mustaphaelmalah.github.io
// @version      0.1
// @description  Disable history pollution from new reddit redesign with post popup
// @author       Mustapha Elmalah
// @match        https://www.reddit.com/*
// @include      https://www.reddit.com/*
// @grant        none
// @downloadURL  https://gist.github.com/mustaphaelmalah/58c9b7035af944f2ba5e/raw/reddit-redesign-nohistory.user.js
// @updateURL    https://gist.github.com/mustaphaelmalah/58c9b7035af944f2ba5e/raw/reddit-redesign-nohistory.meta.js
// ==/UserScript==

history.pushState = function() { }
