import os
import sys
import json
import subprocess

executable_name = "/snap/bin/openscad-nightly"

if len(sys.argv) != 2: 
	print("Usage: python generate_parts.py <setting_file>.json")
	exit()
else:
	job_data = []
	if os.path.exists(sys.argv[1]):
		f = open(sys.argv[1],'r')
		setting_file = json.load(f)
		f.close()
		for i in setting_file: 
			root_job_name = i['name']
			root_scad_file = i['scad']
			global_args = ["{}={}".format(k,v) for k,v in i['global_args']]
			for k in i['parts']:
				part_name = k
				extension = i['parts'][k]['ext']
				part_id = i['parts'][k]['part_id']
				args = ["{}={}".format(_k,_v) for _k,_v in i['parts'][k]['args']]
				job = [executable_name, '-o',"./stl/{}/{}.{}".format(root_job_name, part_name,extension), "--backend=manifold","-D", "{}={}".format("partNumber",part_id)]
				for arg in args:
					job.extend(['-D', arg])
				for arg in global_args:
					job.extend(['-D', arg])
				
				job.append("./user/" +root_scad_file)
				job_data.append(job)
		for j in job_data:
			print("Running OpenSCAD with following args: ", " ".join(j))
			subprocess.run(j)
