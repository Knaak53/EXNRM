Config = {}



Config.songs = 
{
    smoke_water = {
        label = "Smoke on the water",
        value = "smoke_water.ogg",
        guitar = "guitarelectric2"
    },
    melodia_t = {
        label = "Melodia Triste",
        value = "melodia_triste.ogg",
        guitar = "guitar"
    },
    bimbang = {
        label = "Bimbang",
        value = "Bimbang.mp3",
        guitar = "guitar"
    },
    bossa_nova = {
        label = "Bossa Nova",
        value = "bossa_nova.mp3",
        guitar = "guitar"
    }
}

Config.levels = 
{
    Dummy = {
        level = 0,
        label = "Dummy",
        required = 0,
        songs = 
        {
            melodia_t = Config.songs.melodia_t,
        },
    },
    Puntillero = {
        level = 10,
        label = "Puntillero",
        required = 0,
        songs = 
        {
            bimbang = Config.songs.bimbang,
            bossa_nova = Config.songs.bossa_nova
        },
    },
    Flipado = {
        level = 30,
        label = "Flipado",
        required = 0,
        songs = 
        {

        },
        
    },
    Metalero = {
        level = 50,
        label = "Metalero",
        required = 0,
        songs = 
        {

        },
        
    },
    Virtuoso = {
        level = 70,
        label = "Virtuoso",
        required = 0,
        songs = 
        {

        },
    },
    Maestro = {
        level = 90,
        label = "Maestro",
        required = 0,
        songs = 
        {
            smoke_water = Config.songs.smoke_water,
        },
    }
}
