----------------------------RenderPart--------------------------------------
local startFrame = 1
local lastFrame  = 1112
meshname = string.format("Mesh-F%05d", startFrame)


local sceneGraph = octane.project.getSceneGraph()
envimg = sceneGraph:findItemsByName("envimg", true)
rtNodes = sceneGraph:findNodes(octane.NT_RENDERTARGET, true)
MeshNodes = sceneGraph:findNodes(octane.NT_GEO_MESH, true)
teximg = sceneGraph:findItemsByName("MeshTex", true)


for i = startFrame, lastFrame do
    print(i)
    framename = string.format("Atlas-F%05d", i)
    meshfileNum = string.format(i+1)

    octane.render.start{
        renderTargetNode=rtNodes[1]
    }
    
    filePath = string.format("C:/Usr/Octane/Baked/Atlas-F%05d.png", i)
    octane.render.saveImage(filePath, octane.imageSaveType.PNG8)
    
    tex_file_path = string.format("C:/Usr/Octane/Atlas-F%05d.png", meshfileNum)
    teximg[1]:setAttribute(octane.A_FILENAME, tex_file_path)

    mesh_file_path = string.format("C:/Usr/Octane/Mesh-F%05d.obj", meshfileNum)
    MeshNodes[1]:setAttribute(octane.A_FILENAME, mesh_file_path)

    env_file_path = string.format("C://Usr/Octane/img.%05d.exr", meshfileNum)
    envimg[1]:setAttribute(octane.A_FILENAME, env_file_path)

    print (framename)
end
