var bodyEl = document.body;
var firstFilterInputEl = document.querySelector('.main-filter form input');
var audioPlayer = document.getElementById('audio-player');
var filterIsOpen = false;
//trigger event listener on correct checkbox.
document.body.addEventListener('click', (e) =>{
    if(e.target.classList.contains('correct-check')){
        e.target.parentNode.parentNode.classList.toggle('finished');
    }
})

// select all dictionary checkers, if "select all" is checked
var selectAllTrigger = document.querySelector('#selectAll');
var dictionariesSelectEls = document.querySelectorAll('.dictionaries input.selectable')
if (selectAllTrigger && dictionariesSelectEls) {
    selectAllTrigger.addEventListener('change', e =>{
        dictionariesSelectEls.forEach( el =>{
            el.checked = e.target.checked;
        })
    });
}

//check if checkbox in dictionary is deselected and then deselect "select all";
var dictionaryTableEl = document.querySelector('table.dictionaries');
if(dictionaryTableEl){
    dictionaryTableEl.addEventListener('change', (e) =>{
        if(e.target.classList.contains('selectable') && !e.target.checked){
            selectAllTrigger.checked = false;
        }
    })
}


//trigger filter visibility
var filterTrigger = document.querySelector('#filterTrigger');

if(filterTrigger){
    filterTrigger.addEventListener('click', (e)=>{
        bodyEl.classList.toggle('filter-open');
        filterIsOpen = !filterIsOpen;
        if(filterIsOpen){
            firstFilterInputEl.focus();
        }
        else{
            e.target.focus();
        }
    })
}

//add event listeners to use keyboard to open and close filter.
if(firstFilterInputEl){
    bodyEl.addEventListener('keyup', (e)=>{
        if(e.ctrlKey && e.keyCode === 77){
            bodyEl.classList.add('filter-open');
            firstFilterInputEl.focus();
            filterIsOpen = false;
        }

        if(e.keyCode === 27){
            bodyEl.classList.remove('filter-open');
            filterIsOpen = true;
        }
    })
}


//dictionary row - handle events

var dictionaryEntriesEl = document.getElementById('dictionaryEntries');
dictionaryEntriesEl.addEventListener('click', (e)=>{
    var currEl = e.target;
    if(currEl.classList.contains('closeRow')){
        var elEntryParent = currEl.closest('.entry');
        var elFormParent = currEl.closest('.divTableRow');
        elFormParent.remove();
        elEntryParent.classList.remove('edit');
    }
})

/// setup audio player button for entry
var activePlayerButton = null;
audioPlayer.addEventListener('play', function(){
    console.log('start playing');
})
audioPlayer.addEventListener('ended', function(){
    console.log('end playing');
    if(activePlayerButton){
        activePlayerButton.dataset.status = "inactive";
    }
})

document.body.addEventListener('click', (e) =>{
    if(e.target.classList.contains('entry-audio-player') && audioPlayer){
        var isPlaying = e.target.dataset.status;
        if(isPlaying === "active"){
            audioPlayer.pause();
            e.target.dataset.status = "inactive"
        }
        else{
            var src = e.target.dataset.src

            if(src === audioPlayer.src){
                audioPlayer.play();
            }
            else{
                audioPlayer.src = src;
                audioPlayer.play();
            }

            e.target.dataset.status = "active"
            if(activePlayerButton && activePlayerButton !== e.target){
                activePlayerButton.dataset.status = "inactive";
            }
            activePlayerButton = e.target;
        }
    }
})
