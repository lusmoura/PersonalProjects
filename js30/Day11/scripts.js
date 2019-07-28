const player = document.querySelector('.player');
const video = player.querySelector('.viewer');
const progress = player.querySelector('.progress');
const progressBar = player.querySelector('.progress__filled');
const toggle = player.querySelector('.toggle');
const skipButtons = player.querySelectorAll('[data-skip]');
const ranges = player.querySelectorAll('.player__slider');

function togglePlay() {
    if (video.paused) video.play();
    else video.pause();
}

function keyboardPlay(e) {
    if (e.keyCode != 32) return;
    togglePlay();
}

function updateButton() {
    let icon = '';
    if (this.paused) icon = '►';
    else icon = '❚ ❚';
    
    toggle.textContent = icon;
}

function skip() {
    const skipValue = parseFloat(this.dataset.skip);
    video.currentTime +=  skipValue;
}

function hangleRangeUpdate() {
    video[this.name] = this.value;
}

function handleProgess() {
    const percent = (video.currentTime / video.duration) * 100;
    progressBar.style.flexBasis = `${percent}%`;
}

function scrub(e) {
    const scrubTime = (e.offsetX / progress.offsetWidth) * video.duration;
    video.currentTime = scrubTime;
}

document.addEventListener('keydown', keyboardPlay);

video.addEventListener('play', updateButton);
video.addEventListener('pause', updateButton);
video.addEventListener('click', togglePlay);
video.addEventListener('timeupdate', handleProgess);

toggle.addEventListener('click', togglePlay);
skipButtons.forEach(skipButton => skipButton.addEventListener('click', skip));
ranges.forEach(range => range.addEventListener('change', hangleRangeUpdate));
ranges.forEach(range => range.addEventListener('mousemove', hangleRangeUpdate));

let mouseDown = false;
progress.addEventListener('click', scrub);
progress.addEventListener('mousemove', (e) => mouseDown && scrub(e));
progress.addEventListener('mousedown', () => mouseDown = true);
progress.addEventListener('mouseup', () => mouseDown = false);
