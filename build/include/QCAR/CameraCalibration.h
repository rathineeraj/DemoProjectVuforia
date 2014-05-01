/*==============================================================================
Copyright (c) 2010-2013 Qualcomm Connected Experiences, Inc.
All Rights Reserved.
Proprietary - Qualcomm Connected Experiences, Inc.

@file 
    CameraCalibration.h

@brief
    Header file for CameraCalibration class.
==============================================================================*/
#ifndef _QCAR_CAMERACALIBRATION_H_
#define _QCAR_CAMERACALIBRATION_H_

// Include files
#include "Vectors.h"
#include "NonCopyable.h"

namespace QCAR
{

/// Holds intrinsic camera parameters
class QCAR_API CameraCalibration : private NonCopyable
{
public:
    /// Returns the resolution of the camera as 2D vector.
    virtual Vec2F getSize() const = 0;

    /// Returns the focal length in x- and y-direction as 2D vector.
    virtual Vec2F getFocalLength() const = 0;

    /// Returns the principal point as 2D vector.
    virtual Vec2F getPrincipalPoint() const = 0;

    /// Returns the radial distortion as 4D vector.
    virtual Vec4F getDistortionParameters() const = 0;

protected:

    virtual ~CameraCalibration() {}
};

} // namespace QCAR

#endif // _QCAR_CAMERACALIBRATION_H_
