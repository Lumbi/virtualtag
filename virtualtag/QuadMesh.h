//
//  QuadMesh.h
//  virtualtag
//
//  Created by Gabriel Lumbi on 2015-03-09.
//  Copyright (c) 2015 Gabriel Lumbi. All rights reserved.
//

#ifndef virtualtag_QuadMesh_h
#define virtualtag_QuadMesh_h

void newQuadVertices(float width, float height, float quad[12])
{
    quad[0] = -width*0.5f; quad[1] = -height*0.5f; quad[2] = 0.0f; //bottom-left corner
    quad[3] = width*0.5f; quad[4] = -height*0.5f; quad[5] = 0.0f; //bottom-right corner
    quad[6] = width*0.5f; quad[7] = height*0.5f; quad[8] = 0.0f; //top-right corner
    quad[9] = -width*0.5f; quad[10] = height*0.5f; quad[11] = 0.0f; //top-left corner
}

//static const float quadVertices[] =
//{
//    -0.5f, -0.5f, 0.0f, //bottom-left corner
//    0.5f, -0.5f, 0.0f, //bottom-right corner
//    0.5f, 0.5f, 0.0f, //top-right corner
//    -0.5f, 0.5f, 0.0f //top-left corner
//};

static const float quadTexcoords[] =
{
    0.0f, 1.0f, //tex-coords at bottom-left corner
    1.0f, 1.0f, //tex-coords at bottom-right corner
    1.0f, 0.0f, //tex-coords at top-right corner
    0.0f, 0.0f //tex-coords at top-left corner
};
static const float quadNormals[] =
{
    0.0f, 0.0f, 1.0f, //normal at bottom-left corner
    0.0f, 0.0f, 1.0f, //normal at bottom-right corner
    0.0f, 0.0f, 1.0f, //normal at top-right corner
    0.0f, 0.0f, 1.0f //normal at top-left corner
};
static const unsigned short quadIndices[] =
{
    0, 1, 2, // triangle 1
    2, 3, 0 // triangle 2
};

#endif
