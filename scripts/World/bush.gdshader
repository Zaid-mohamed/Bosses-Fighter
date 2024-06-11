shader_type canvas_item;


//###########################
//###########################

//This Code Is Temporary, I will try to make this effect by gdscript,
// to make player movement affect the bush

//###########################
//###########################

void vertex() {
	
	// if the vertex is above the center
	
	if (VERTEX.y < 0.0){
	// increase the vertex.x by the sin of time * 10.0 
	VERTEX.x  += sin(TIME) * 5.0;
	 }
}


