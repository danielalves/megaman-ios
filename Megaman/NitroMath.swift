/**
*  @file NitroMath.swift
*
*  @brief Contains mathematical utilities for Swift
*
*  @author Daniel L. Alves, copyright 2014
*
*  @since 04/06/2014
*/

import Foundation

/*******************************************************

General functions

*******************************************************/

/**
*  Linear interpolation. That is, calculates a value fitted between x and  y,
*  given a percentage of the distance traveled between them. This version is
*  optmized for floating point values. To avoid conversions when using integer
*  values, use lerpi.
*
*  @param percent How much of the distance between x and y have been traveled. 0.0f means
*                 0%, 1.0f means 100%.
*  @param x       The starting point of the linear interpolation
*  @param y       The ending point of the linear interpolation
*
*  @return A value interpolated between x and y
*
*  @see lerpi
*/
func lerp( percent: CFloat, x: CFloat, y: CFloat ) -> CFloat { return x + ( percent * ( y - x ) ) }

/**
*  Linear interpolation. That is, calculates a value fitted between x and y,
*  given a percentage of the distance traveled between them. This version is
*  optmized for integer values. To avoid conversions when using floating point
*  values, use lerp.
*
*  @param percent How much of the distance between x and y have been traveled. 0 means
*                 0%, 100 means 100%.
*  @param x       The starting point of the linear interpolation
*  @param y       The ending point of the linear interpolation
*
*  @return A value interpolated between x and y
*
*  @see lerp
*/
func lerpi( percent: CInt, x: CInt, y: CInt ) -> CInt {  return x + (( percent * ( y - x )) / 100 ) }

/**
*  Returns a value clamped between the interval [min, max]. That is, if the value is
*  lesser than min, the result is min. If the value is greater than max, the result is
*  max. This version is optmized for floating point values. To avoid conversions when
*  using integer values, use clampi.
*
*  @param x   The value to clamp
*  @param min The min boundary of the accepted interval
*  @param max The max boundary of the accepted interval
*
*  @return A value clamped between the interval [min, max]
*
*  @see clampi
*/
func clamp( x: CFloat, min: CFloat, max: CFloat ) -> CFloat { return x <= min ? min : ( x >= max ? max : x ) }

/**
*  Returns a value clamped between the interval [min, max]. That is, if the value is
*  lesser than min, the result is min. If the value is greater than max, the result is
*  max. This version is optmized for integer values. To avoid conversions when using
*  floating point values, use clamp.
*
*  @param x   The value to clamp
*  @param min The min boundary of the accepted interval
*  @param max The max boundary of the accepted interval
*
*  @return A value clamped between the interval [min, max]
*
*  @see clamp
*/
func clampi( x: CInt, min: CInt, max: CInt ) -> CInt { return x <= min ? min : ( x >= max ? max : x ) }

/**
*  Returns the luminance of a RGB color. The results will be incorrect if there are components
*  with values less than zero or greater than one.
*
*  @param r The red component of the color
*  @param g The green component of the color
*  @param b The blue component of the color
*
*  @return The luminance of the color
*
*  @see luminancei
*/
func luminance( r: CFloat, g: CFloat, b: CFloat ) -> CFloat { return ( r * 0.299 ) + ( g * 0.587 ) + ( b * 0.114 ) }

/**
*  Returns the luminance of a RGB color
*
*  @param r The red component of the color
*  @param g The green component of the color
*  @param b The blue component of the color
*
*  @return The luminance of the color
*
*  @see luminance
*/
func luminancei( r: UInt8, g: UInt8, b: UInt8 ) -> UInt8 { return ( UInt8 )((( r * 76 ) + ( g * 150 ) + ( b * 29 )) / 255 ) }

/*******************************************************

Conversion functions

*******************************************************/

/**
*  Converts degrees to radians
*
*  @param degrees A value in degrees
*
*  @return A value in radians
*
*  @see radiansToDegrees
*/
func degreesToRadians( degrees: CFloat ) -> CFloat { return ( degrees * CFloat(M_PI) ) / 180.0 }

/**
*  Converts radians to degrees
*
*  @param radians A value in radians
*
*  @return A value in degrees
*
*  @see degreesToRadians
*/
func radiansToDegrees( radians: CFloat ) -> CFloat { return ( 180.0 * radians ) / CFloat(M_PI) }

/*******************************************************

Floating point numbers absolute error comparison utilities

Although these functions are not suited for all floating point
comparison cases, they will do fine many times.

For a more in-depth discussion and other (way better) algorithms, see:
- http://randomascii.wordpress.com/2012/02/25/comparing-floating-point-numbers-2012-edition/
- http://randomascii.wordpress.com/category/floating-point/
- http://www.cygnus-software.com/papers/comparingfloats/comparingfloats.htm

*******************************************************/

/**
*  Compares two floating point numbers, considering them different only if
*  the difference between them is greater than epsilon
*
*  @return -1 if f1 is lesser than f2
*  @return  0 if f1 and f2 are considered equal
*  @return  1 if f1 is greater than f2
*
*  @see fcmp, feql_e, feql, fdif_e, fdif, fltn_e, fltn, fgtn_e, fgtn, fleq_e, fleq, fgeq_e, fgeq
*/
func fcmp_e( f1: CFloat, f2: CFloat, epsilon: CFloat ) -> Int8 { return fabsf( f1 - f2 ) <= epsilon ? 0 : ( f1 > f2 ? 1 : -1 ) }

/**
*  Compares two floating point numbers, considering them different only if
*  the difference between them is greater than FLT_EPSILON
*
*  @return -1 if f1 is lesser than f2
*  @return  0 if f1 and f2 are considered equal
*  @return  1 if f1 is greater than f2
*
*  @see fcmp_e, feql_e, feql, fdif_e, fdif, fltn_e, fltn, fgtn_e, fgtn, fleq_e, fleq, fgeq_e, fgeq
*/
func fcmp( f1: CFloat, f2: CFloat ) -> Int8 { return fcmp_e( f1, f2, FLT_EPSILON ) }

/**
*  Returns if f1 is equal to f2. The numbers are considered different only if
*  the difference between them is greater than epsilon
*
*  @see fcmp_e, fcmp, feql, fdif_e, fdif, fltn_e, fltn, fgtn_e, fgtn, fleq_e, fleq, fgeq_e, fgeq
*/
func feql_e( f1: CFloat, f2: CFloat, epsilon: CFloat ) -> Bool { return fcmp_e( f1, f2, epsilon ) == 0 }

/**
*  Returns if f1 is equal to f2. The numbers are considered different only if
*  the difference between them is greater than FLT_EPSILON
*
*  @see fcmp_e, fcmp, feql_e, fdif_e, fdif, fltn_e, fltn, fgtn_e, fgtn, fleq_e, fleq, fgeq_e, fgeq
*/
func feql( f1: CFloat, f2: CFloat ) -> Bool { return feql_e( f1, f2, FLT_EPSILON ) }

/**
*  Returns if f1 is different from f2. The numbers are considered different only if
*  the difference between them is greater than epsilon
*
*  @see fcmp_e, fcmp, feql_e, feql, fdif, fltn_e, fltn, fgtn_e, fgtn, fleq_e, fleq, fgeq_e, fgeq
*/
func fdif_e( f1: CFloat, f2: CFloat, epsilon: CFloat ) -> Bool { return fcmp_e( f1, f2, epsilon ) != 0 }

/**
*  Returns if f1 is different from f2. The numbers are considered different only if
*  the difference between them is greater than FLT_EPSILON
*
*  @see fcmp_e, fcmp, feql_e, feql, fdif_e, fltn_e, fltn, fgtn_e, fgtn, fleq_e, fleq, fgeq_e, fgeq
*/
func fdif( f1: CFloat, f2: CFloat ) -> Bool { return fdif_e( f1, f2, FLT_EPSILON ) }

/**
*  Returns if f1 is lesser than f2. The numbers are considered different only if
*  the difference between them is greater than epsilon
*
*  @see fcmp_e, fcmp, feql_e, feql, fdif_e, fdif, fltn, fgtn_e, fgtn, fleq_e, fleq, fgeq_e, fgeq
*/
func fltn_e( f1: CFloat, f2: CFloat, epsilon: CFloat ) -> Bool { return fcmp_e( f1, f2, epsilon ) == -1 }

/**
*  Returns if f1 is lesser than f2. The numbers are considered different only if
*  the difference between them is greater than FLT_EPSILON
*
*  @see fcmp_e, fcmp, feql_e, feql, fdif_e, fdif, fltn_e, fgtn_e, fgtn, fleq_e, fleq, fgeq_e, fgeq
*/
func fltn( f1: CFloat, f2: CFloat ) -> Bool { return fltn_e( f1, f2, FLT_EPSILON ) }

/**
*  Returns if f1 is greater than f2. The numbers are considered different only if
*  the difference between them is greater than epsilon
*
*  @see fcmp_e, fcmp, feql_e, feql, fdif_e, fdif, fltn_e, fltn, fgtn, fleq_e, fleq, fgeq_e, fgeq
*/
func fgtn_e( f1: CFloat, f2: CFloat, epsilon: CFloat ) -> Bool { return fcmp_e( f1, f2, epsilon ) == 1 }

/**
*  Returns if f1 is greater than f2. The numbers are considered different only if
*  the difference between them is greater than FLT_EPSILON
*
*  @see fcmp_e, fcmp, feql_e, feql, fdif_e, fdif, fltn_e, fltn, fgtn_e, fleq_e, fleq, fgeq_e, fgeq
*/
func fgtn( f1: CFloat, f2: CFloat ) -> Bool { return fgtn_e( f1, f2, FLT_EPSILON ) }

/**
*  Returns if f1 is lesser or equal to f2. The numbers are considered different only if
*  the difference between them is greater than epsilon
*
*  @see fcmp_e, fcmp, feql_e, feql, fdif_e, fdif, fltn_e, fltn, fgtn_e, fgtn, fleq, fgeq_e, fgeq
*/
func fleq_e( f1: CFloat, f2: CFloat, epsilon: CFloat ) -> Bool { return fcmp_e( f1, f2, epsilon ) <= 0 }

/**
*  Returns if f1 is lesser or equal to f2. The numbers are considered different only if
*  the difference between them is greater than FLT_EPSILON
*
*  @see fcmp_e, fcmp, feql_e, feql, fdif_e, fdif, fltn_e, fltn, fgtn_e, fgtn, fleq_e, fgeq_e, fgeq
*/
func fleq( f1: CFloat, f2: CFloat ) -> Bool { return fleq_e( f1, f2, FLT_EPSILON ) }

/**
*  Returns if f1 is greater or equal to f2. The numbers are considered different only if
*  the difference between them is greater than epsilon
*
*  @see fcmp_e, fcmp, feql_e, feql, fdif_e, fdif, fltn_e, fltn, fgtn_e, fgtn, fleq_e, fleq, fgeq_e, fgeq
*/
func fgeq_e( f1: CFloat, f2: CFloat, epsilon: CFloat ) -> Bool { return fcmp_e( f1, f2, epsilon ) >= 0 }

/**
*  Returns if f1 is greater or equal to f2. The numbers are considered different only if
*  the difference between them is greater than FLT_EPSILON
*
*  @see fcmp_e, fcmp, feql_e, feql, fdif_e, fdif, fltn_e, fltn, fgtn_e, fgtn, fleq_e, fleq, fgeq_e
*/
func fgeq( f1: CFloat, f2: CFloat ) -> Bool { return fgeq_e( f1, f2, FLT_EPSILON ) }
