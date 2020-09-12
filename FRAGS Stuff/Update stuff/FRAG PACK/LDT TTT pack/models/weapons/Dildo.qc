$cd "C:\Dildo"
$modelname "Dildo.mdl"
$model "studio" "dildo_flip normals.smd"
$cdmaterials "models\Dildotextures\"

$hboxset "default"
$surfaceprop "metal"
$keyvalues  { prop_data { "base" "metal.Small"  } } 
$sequence idle "dildo_anim.smd" fps 1.00
$collisionmodel "dildo.smd" {
	$concave
	$mass 0.2
	$inertia 1.00
	$damping 0.00
	$rotdamping 0.00
}