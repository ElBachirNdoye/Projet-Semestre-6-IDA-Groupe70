function afficher(id){

    let contenu = document.getElementById(id);

    if(contenu.style.display === "block"){
        contenu.style.display = "none";
    }
    else{
        contenu.style.display = "block";
    }

}


const form = document.getElementById("contactForm");

form.addEventListener("submit", function(event) {
    event.preventDefault();

    alert("Votre message a été envoyé avec succès !");

    form.reset();
});