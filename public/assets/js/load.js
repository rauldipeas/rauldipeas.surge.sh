window.onload = function () {
    document.body.classList.remove('is-preload');
}
window.ontouchmove = function () {
    return false;
}
window.onorientationchange = function () {
    document.body.scrollTop = 0;
}