for (let dropbox of document.querySelectorAll('.drop-box')) {
    let dropButton = dropbox.querySelector(".drop-button");
    let dropMenu = dropbox.querySelector(".drop-menu");
  
    document.body.addEventListener("click", function(e) {
      let target = e.target || e.srcElement;
      if (target !== dropbox && !isChildOf(target, dropbox)) {
        dropbox.classList.remove("active");
      }
    }, false);
  
    function isChildOf(child, parent) {
      if (child.parentNode === parent) {
        return true;
      } else if (child.parentNode === null) {
        return false;
      } else {
        return isChildOf(child.parentNode, parent);
      }
    }
  
    dropButton.addEventListener("click", function(e) {
      dropbox.classList.toggle("active");
      for (let link of dropMenu.querySelectorAll('.link')) {
        link.classList.remove("active");
      }    
    }, false);
  
    let xx = 0;
    for (let link of dropMenu.querySelectorAll('.link')) {
      (function(index){
        link.addEventListener("click", function() {
          let yy = 0;
          for (let links of dropMenu.querySelectorAll('.link')) {
            if (index !== yy) {
              links.classList.remove("active");
            }          
            yy++
          }
          this.classList.toggle("active");
        })
      })(xx);
      xx++;
    }
  
  }