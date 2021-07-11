Config = {}
Config.enterMarker = 36
Config.markerColour = {r=29,g=36,b=239,a=254}
Config.parkMarkerColour = {r=255,g=255,b=51,a=30}
Config.parkMarkerType = 43
Config.DebugMode = true
Config.garages = {
    Central={
        name = "Central",
        label = "Parking",
        shell = 'shell_garagel',
        enterCoords = vector3(-9.7506713867188,-724.91986083984,32.328895568848),
        type = "public",--Definimos si es publico o privado si es publico se le verá a todo el mundo si es privado hay que ponerle un nombre diferente
        floors = 8,
        capacity = 13,
        blip = 267,
        blipColour = 38,
        enter = true
    },
    Casino={
        name = "Casino",
        label = "Parking",
        shell = 'shell_garagel',
        enterCoords = vector3(931.13,-7.75,78.29),
        type = "public",--Definimos si es publico o privado si es publico se le verá a todo el mundo si es privado hay que ponerle un nombre diferente
        floors = 8,
        capacity = 13,
        blip = 267,
        blipColour = 38,
        enter = true
    },
    Hospital={
        name = "Hospital",
        label = "Parking hospital",
        shell = 'shell_garagel',
        enterCoords = vector3(328.64605712891,-558.58520507812,28.743776321411),
        type = "ambulance",--Definimos si es publico o privado si es publico se le verá a todo el mundo si es privado hay que ponerle un nombre diferente
        floors = 3,
        capacity = 13,
        blip = 118,
        blipColour = 5,
        enter = true
    },
    Policia={
        name = "Policia",
        label = "Parking policial",
        shell = 'shell_garagel',
        enterCoords = vector3(449.99084472656,-1013.0579833984,29.490533828735),
        type = "police",--Definimos si es publico o privado si es publico se le verá a todo el mundo si es privado hay que ponerle un nombre diferente
        floors = 3,
        capacity = 13,
        blip = 473,
        blipColour = 3,
        enter = true
    },
    Central2={
        name = "Central2",
        label = "Parking",
        shell = 'shell_garagel',
        enterCoords = vector3(120.14580535889,-1116.3682861328,29.185657501221),
        type = "public",--Definimos si es publico o privado si es publico se le verá a todo el mundo si es privado hay que ponerle un nombre diferente
        floors = 8,
        capacity = 13,
        blip = 267,
        blipColour = 38,
        enter = true
    },
    Central3 = {
        name = "Central3",
        label = "Parking",
        shell = 'shell_garagel',
        enterCoords = vector3(-718.99462890625,-59.205425262451,37.205509185791),
        type = "public",--Definimos si es publico o privado si es publico se le verá a todo el mundo si es privado hay que ponerle un nombre diferente
        floors = 7,
        capacity = 13,
        blip = 267,
        blipColour = 38,
        enter = true
    },
    Central4 = {
        name = "Central4",
        label = "Parking",
        shell = 'shell_garagel',
        enterCoords = vector3(-305.58715820312,-707.68615722656,29.33772277832),
        type = "public",--Definimos si es publico o privado si es publico se le verá a todo el mundo si es privado hay que ponerle un nombre diferente
        floors = 5,
        capacity = 13,
        blip = 267,
        blipColour = 38,
        enter = true
    },
    Mecanicos = {
        name = "Mecanicos",
        label = "Garage Mecanicos",
        shell = 'shell_warehouse2',
        enterCoords = vector3(-164.68006896973,-1294.2163085938,31.276973724365),
        type = "mechanic",--Definimos si es publico o privado si es publico se le verá a todo el mundo si es privado hay que ponerle un nombre diferente
        floors = 5,
        capacity = 15,
        blip = 267,
        blipColour = 38,
        enter = true
    },
    IndustrialSave = {
        name = "Mecanicos",
        label = "Garage Mecanicos",
        shell = 'shell_warehouse2',
        enterCoords = vector3(804.58862304688,-2222.8894042969,29.479856491089),
        type = "public",--Definimos si es publico o privado si es publico se le verá a todo el mundo si es privado hay que ponerle un nombre diferente
        floors = 8,
        capacity = 15,
        blip = 67,
        blipColour = 38,
        enter = true
    },
}
---Queda meterle el heading a cada shell para spawnear bien los blips y los puntos de entrada
Config.GarageSpawns = {
    shell_garagem ={
        Spawns ={
            {z=-1.3733444213867188,y=4.4217987060546877,x=-5.4090576171875,id = 1,ParkingMarkerZ = -1.93,heading = vector3(0,0,0)},
            {z=-1.3733444213867188,y=4.4217987060546877,x=0.4090576171875,id = 2,ParkingMarkerZ = -1.93,heading = vector3(0,0,0)},
            {z=-1.3733444213867188,y=4.4217987060546877,x=5.4090576171875,id = 3,ParkingMarkerZ = -1.93,heading = vector3(0,0,0)},
        },
        WalkingExitOffset = {y=1.5645751953125,x=12.763673782348633,z=0.9492568969726563,markz=-0.8, heading = 85.8},
        DrivingExitOffset = {z=1.3730010986328126,y=-6.2900238037109375,x=3.0797119140625,markz=-0.8, heading = 357.0},
        Capacity = 3
    },
    shell_warehouse1 ={
        Spawns ={
            {z=-1.3733444213867188,y=2.4217987060546877,x=-5.4090576171875,id = 1,ParkingMarkerZ = -1.93,heading = vector3(0,0,0)},
            {z=-1.3732528686523438,y=-2.3483505249023439,x=-5.232177734375,id = 2,ParkingMarkerZ = -1.93,heading = vector3(0,0,0)},
            {z=-1.3734359741210938,y=-2.2885055541992189,x=1.5408935546875,id = 3,ParkingMarkerZ = -1.93,heading = vector3(0,0,0)},
        },
        WalkingExitOffset = {y=0.05645751953125,x=-7.763673782348633,z=0.9492568969726563,markz=-0.8},
        DrivingExitOffset = {z=1.3730010986328126,y=0.2900238037109375,x=6.0797119140625,markz=-0.8},
        Capacity = 3
    },
    shell_warehouse2 ={
        Spawns ={
            {x=10.985404968262,z=-2.482536315918,y=-6.0016460418701,id = 1,ParkingMarkerZ = -3.0,heading = vector3(0,0,0)},
            {x=7.7909126281738,z=-2.4830322265625,y=-6.0148735046387,id = 2,ParkingMarkerZ = -3.0,heading = vector3(0,0,0)},
            {x=11.017581939697,z=-2.4824981689453,y=6.0757713317871,id = 3,ParkingMarkerZ = -3.0,heading = vector3(0,0,0)},
            {x=7.9139060974121,z=-2.4830169677734,y=5.8254737854004,id = 4,ParkingMarkerZ = -3.0,heading = vector3(0,0,0)},
            {x=4.5694694519043,z=-2.4828109741211,y=-5.9094200134277,id = 5,ParkingMarkerZ = -3.0,heading = vector3(0,0,0)},
            {x=1.4202499389648,z=-2.482780456543,y=-5.8627853393555,id = 6,ParkingMarkerZ = -3.0,heading = vector3(0,0,0)},
            {x=1.4497375488281,z=-2.4827728271484,y=6.0737838745117,id = 7,ParkingMarkerZ = -3.0,heading = vector3(0,0,0)},
            {x=4.7661476135254,z=-2.4824981689453,y=6.0173454284668,id = 8,ParkingMarkerZ = -3.0,heading = vector3(0,0,0)},
            {x=-1.4563598632813,z=-2.4827117919922,y=5.9438438415527,id = 9,ParkingMarkerZ = -3.0,heading = vector3(0,0,0)},
            {x=-1.5919342041016,z=-2.4827880859375,y=-6.0630741119385,id = 10,ParkingMarkerZ = -3.0,heading = vector3(0,0,0)},
            {x=-4.924732208252,z=-2.4824829101563,y=6.2334594726563,id = 11,ParkingMarkerZ = -3.0,heading = vector3(0,0,0)},
            {x=-4.7544136047363,z=-2.4826049804688,y=-6.0570240020752,id = 12,ParkingMarkerZ = -3.0,heading = vector3(0,0,0)},
            {x=-8.365665435791,z=-2.482536315918,y=6.2552642822266,id = 13,ParkingMarkerZ = -3.0,heading = vector3(0,0,0)},
            {x=-7.9048957824707,z=-2.4828338623047,y=-6.2867012023926,id = 14,ParkingMarkerZ = -3.0,heading = vector3(0,0,0)},
            {x=-11.321949005127,z=-2.4825973510742,y=-6.1671848297119,id = 15,ParkingMarkerZ = -3.0,heading = vector3(0,0,0)},
        },
        WalkingExitOffset = {y=5.42822125738525,z=-2.0591201782226564,x=-11.900007247924805,markz=-2.5},
        DrivingExitOffset = {y=0.13411140441895,z=-2.4828262329102,x=9.8168478012085,markz=-2.5},
        Capacity = 15
    },
    shell_warehouse3 ={

    },
    shell_garagel ={
        Spawns ={
            --{z=-1.3733444213867188,y=7.4217987060546877,x=-5.4090576171875,id = 1,ParkingMarkerZ = -1.93},
            --{z=-1.3733444213867188,y=2.4217987060546877,x=-5.4090576171875,id = 1,ParkingMarkerZ = -1.93},
            --{z=-1.3732528686523438,y=-2.3483505249023439,x=-5.232177734375,id = 2,ParkingMarkerZ = -1.93},
            --{z=-1.3732528686523438,y=-7.3483505249023439,x=-5.232177734375,id = 2,ParkingMarkerZ = -1.93},
            --{z=-1.3734359741210938,y=-2.4885055541992189,x=5.5408935546875,id = 3,ParkingMarkerZ = -1.93},
            --{z=-1.3734359741210938,y=-2.2885055541992189,x=5.5408935546875,id = 3,ParkingMarkerZ = -1.93},
            --{z=-1.3734359741210938,y=-7.2885055541992189,x=5.5408935546875,id = 3,ParkingMarkerZ = -1.93},
            {y= 13.723388671875,z= -1.4262619018554688,x= -5.1221923828125,id = 1,ParkingMarkerZ = -1.93,heading = vec(0, 0, 90)},
            {y= 9.890380859375,z= -1.4242477416992188,x= -4.7049560546875,id = 2,ParkingMarkerZ = -1.93,heading = vec(0, 0, 90)},
            {y= 5.72412109375,z= -1.425445556640625,x= -4.5003662109375,id = 3,ParkingMarkerZ = -1.93,heading = vec(0, 0, 90)},
            {y= 1.8310546875,z= -1.4239387512207032,x= -4.5526123046875,id = 4,ParkingMarkerZ = -1.93,heading = vec(0, 0, 90)},
            {y= -2.0185546875,z= -1.4256744384765626,x= -4.80908203125,id = 5,ParkingMarkerZ = -1.93,heading = vec(0, 0, 90)},
            {y= -6.048828125,z= -1.4233779907226563,x= -4.7003173828125,id = 6,ParkingMarkerZ = -1.93,heading = vec(0, 0, 90)},
            {y= -10.078857421875,z= -1.4233207702636719,x= -4.50927734375,id = 7,ParkingMarkerZ = -1.93,heading = vec(0, 0, 90)},
            --{y= -10.30322265625,z= -1.4235954284667969,x= 5.095947265625,id = 8,ParkingMarkerZ = -1.93},
            --{y= -6.770263671875,z= -1.4235115051269532,x= 4.94189453125,id = 9,ParkingMarkerZ = -1.93},
            --{y= -2.542724609375,z= -1.4238739013671876,x= 5.0068359375,id = 10,ParkingMarkerZ = -1.93},
            --{y= 1.55908203125,z= -1.4238967895507813,x= 5.242919921875,id = 11,ParkingMarkerZ = -1.93},
            --{y= 5.670654296875,z= -1.4244956970214844,x= 5.0025634765625,id = 12,ParkingMarkerZ = -1.93},
            --{y= 9.400146484375,z= -1.4235649108886719,x= 4.9627685546875,id = 13,ParkingMarkerZ = -1.93},
        },
        --WalkingExitOffset = {y=-14.05645751953125,x=12.763673782348633,z=1.5492568969726563,markz=-0.8},
        WalkingExitOffset = {y=-14.65645751953125,x=12.0763673782348633,z=1.5492568969726563,markz=-0.8, heading = 77.9},
        DrivingExitOffset = {z=1.3730010986328126,y=-14.2900238037109375,x=-1.0797119140625,markz=-0.8, heading = 356.09},
        Capacity = 7
    },
}
