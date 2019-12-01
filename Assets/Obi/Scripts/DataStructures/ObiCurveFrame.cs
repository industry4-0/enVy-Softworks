﻿using System;
using UnityEngine;

namespace Obi
{
	public class ObiCurveFrame{

		public Vector3 position = Vector3.zero;
		public Vector3 tangent = Vector3.forward;
		public Vector3 normal = Vector3.up;
		public Vector3 binormal = Vector3.right;

		public void Reset(){
			position = Vector3.zero;
			tangent = Vector3.forward;
			normal = Vector3.up;
			binormal = Vector3.right;
		}

		public void SetTwist(float twist){
			Quaternion twistQ = Quaternion.AngleAxis(twist,tangent);
			normal = twistQ*normal;
			binormal = twistQ*binormal;
		}

		public void SetTwistAndTangent(float twist, Vector3 tangent){
			this.tangent = tangent;
			normal = new Vector3(tangent.y,tangent.x,0).normalized;
			binormal = Vector3.Cross(normal,tangent);

			Quaternion twistQ = Quaternion.AngleAxis(twist,tangent);
			normal = twistQ*normal;
			binormal = twistQ*binormal;
		}

		public void Transport(Vector3 newPosition, Vector3 newTangent, float twist){

			// Calculate delta rotation:
			Quaternion rotQ = Quaternion.FromToRotation(tangent,newTangent);
			Quaternion twistQ = Quaternion.AngleAxis(twist,newTangent);
			Quaternion finalQ = twistQ*rotQ;
			
			// Rotate previous frame axes to obtain the new ones:
			normal = finalQ*normal;
			binormal = finalQ*binormal;
			tangent = newTangent;
			position = newPosition;

		}

		public void Transport(ObiCurveSection section, float twist){

			// Calculate delta rotation:
			Quaternion rotQ = Quaternion.FromToRotation(tangent,section.tangent);
			Quaternion twistQ = Quaternion.AngleAxis(twist,section.tangent);
			Quaternion finalQ = twistQ*rotQ;
			
			// Rotate previous frame axes to obtain the new ones:
			normal = finalQ*normal;
			binormal = finalQ*binormal;
			tangent = section.tangent;
			position = section.positionAndRadius;

		}

		public void Set(ObiCurveSection section){
			normal = section.normal;
			tangent = section.tangent;
			binormal = Vector3.Cross(normal,tangent);
			position = section.positionAndRadius;
		}

		public void DrawDebug(float length){
			Debug.DrawRay(position,normal*length,Color.blue);
			Debug.DrawRay(position,tangent*length,Color.red);
			Debug.DrawRay(position,binormal*length,Color.green);
		}

		/** 
		 * This method uses Chainkin's algorithm to produce a smooth curve from a set of control points. It is specially fast
		 * because it directly calculates subdivision level k, instead of recursively calculating levels 1..k.
		 */
		public static void Chaikin(ObiList<ObiCurveSection> input, ObiList<ObiCurveSection> output, uint k)
		{
			// no subdivision levels, no work to do. just copy the input to the output:
			if (k == 0 || input.Count < 3){
				output.SetCount(input.Count);
				for (int i = 0; i < input.Count; ++i)
					output[i] = input[i];
				return;
			}

			// calculate amount of new points generated by each inner control point:
			int pCount = (int)Mathf.Pow(2,k);

			// precalculate some quantities:
			int n0 = input.Count-1;
			float twoRaisedToMinusKPlus1 = Mathf.Pow(2,-(k+1));
			float twoRaisedToMinusK = Mathf.Pow(2,-k);
			float twoRaisedToMinus2K = Mathf.Pow(2,-2*k);
			float twoRaisedToMinus2KMinus1 = Mathf.Pow(2,-2*k-1);

			// allocate ouput:
			output.SetCount((n0-1) * pCount + 2); 

			// calculate initial curve points:
			output[0] = 				 (0.5f + twoRaisedToMinusKPlus1) * input[0] + (0.5f - twoRaisedToMinusKPlus1) * input[1];
			output[pCount*n0-pCount+1] = (0.5f - twoRaisedToMinusKPlus1) * input[n0-1] + (0.5f + twoRaisedToMinusKPlus1) * input[n0];

			// calculate internal points:
			for (int j = 1; j <= pCount; ++j){

				// precalculate coefficients:
				float F = 0.5f - twoRaisedToMinusKPlus1 - (j-1)*(twoRaisedToMinusK - j*twoRaisedToMinus2KMinus1);
				float G = 0.5f + twoRaisedToMinusKPlus1 + (j-1)*(twoRaisedToMinusK - j*twoRaisedToMinus2K); 
				float H = (j-1)*j*twoRaisedToMinus2KMinus1;

				for (int i = 1; i < n0; ++i){
					output[(i-1)*pCount+j] = F*input[i-1] + G*input[i] + H*input[i+1];
				}
			}

			// make first and last curve points coincide with original points:
			output[0] = input[0];	
			output[output.Count-1] = input[input.Count-1];	
		}	
	}

}
