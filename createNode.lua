------------------------Make graph part-------------------------------------------

local startFrame = 1
local sampleNum = {150, 0, 0}
local resNum = {2048, 2048, 0}
local rayepsilonNum = {0.1, 0.0, 0.0}
local BakeIDNum = {3, 0, 0}
local TransformNum = {0, -200, 280}

--Make BakeID
BakeID = octane.node.create{
    type = octane._NT_INT2,
    name = "BakeID"
    }
BakeID:setAttribute(octane.A_VALUE, BakeIDNum)

--Setting up Environment

envimg = octane.node.create{
    type = octane.NT_TEX_IMAGE,
    name = "envimg"
    }
envimg:setAttribute(octane.A_FILENAME, "C://Usr/Octane/img_00001.exr")
env = octane.node.create{
    type = octane.NT_ENV_TEXTURE,
    name = "environment"
    }
env:connectTo(octane.P_TEXTURE, envimg)


--Make camera
cam = octane.node.create{
    type = octane.NT_CAM_BAKING,
    name = "bake cam"
    }
cam:connectTo(octane.P_BAKING_GROUP_ID, BakeID)

--Make FilmSetting
res = octane.node.create{
    type = octane._NT_INT2,
    name = "res"
    }
res:setAttribute(octane.A_VALUE, resNum)

fsettings = octane.node.create{
    type = octane.NT_FILM_SETTINGS,
    name = "FilmSettings"
    }
fsettings:connectTo(octane.P_RESOLUTION, res)

--Make karnel setting
sample = octane.node.create{
    type = octane._NT_INT2,
    name = "sample"
    }
sample:setAttribute(octane.A_VALUE, sampleNum)

rayepsilon = octane.node.create{
    type = octane.NT_FLOAT,
    name = "reyepsilon"
    }
rayepsilon:setAttribute(octane.A_VALUE, rayepsilonNum)

kernel = octane.node.create{
    type = octane.NT_KERN_DIRECTLIGHTING,
    name = "kernel"
    }
kernel:connectTo(octane.P_MAX_SAMPLES, sample)
kernel:connectTo(octane.P_RAY_EPSILON, rayepsilon)

--Make Imager Camera
Imager = octane.node.create{
    type = octane.NT_IMAGER_CAMERA,
    name = "Imager"
}


for i=startFrame, startFrame do
    meshname = string.format("Mesh-F%05d", i)

    --Load Mesh
    mesh_file_path = string.format("C:/Usr/Octane/Mesh_F%05d.obj", i)
    mesh = octane.node.create{
    type = octane.NT_GEO_MESH,
    name = meshname
    }
    --Load texture
    tex_file_path = string.format("C:/Usr/Octane/Img_F%05d.png", i)
    texname = string.format("Mesh_F%05d.png", i)

    tex = octane.node.create{
    type = octane.NT_TEX_IMAGE,
    name = "MeshTex"
    }

    tex:setAttribute(octane.A_FILENAME, tex_file_path)

    --Make material
    matname = string.format("Mesh_F%05d", i)
    mat = octane.node.create{
    type = octane.NT_MAT_DIFFUSE,
    name = meshname
    }

    mat:connectTo(octane.P_DIFFUSE, tex)
    mesh:setAttribute(octane.A_FILENAME, mesh_file_path)
    mesh:connectToIx(1,mat)


    objLayerMap = octane.node.create{
    type = octane.NT_OBJECTLAYER_MAP,
    name = "objLayerMAP"
    }


    rtNode = octane.node.create{
    type = octane.NT_RENDERTARGET,
    name = meshname
    }
    Group = octane.node.create{
    type = octane.NT_GEO_GROUP,
    name = meshname.."GP"
    }

    objLayerMap:connectTo(octane.P_GEOMETRY, mesh)
    Group:setAttribute(octane.A_PIN_COUNT, 2)
    Group:connectToIx(1,objLayerMap)

    rtNode:connectTo(octane.P_MESH, Group)
    rtNode:connectTo(octane.P_CAMERA, cam)
    rtNode:connectTo(octane.P_FILM_SETTINGS, fsettings)
    rtNode:connectTo(octane.P_ENVIRONMENT, env)
    rtNode:connectTo(octane.P_KERNEL, kernel)
    rtNode:connectTo(octane.P_IMAGER, Imager)

end
