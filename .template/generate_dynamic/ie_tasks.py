import os
from os import path
import shutil, glob
import logging
import uuid
import hashlib
from subprocess import PIPE, STDOUT

import lib
from lib import CouldNotLocate, task

LOG = logging.getLogger(__name__)

class IEError(Exception):
	pass

@task
def package_ie(build, **kw):
	'Sign executables, Run NSIS'
	
	# NSIS
	nsis_check = lib.PopenWithoutNewConsole('makensis -VERSION', shell=True, stdout=PIPE, stderr=STDOUT)
	stdout, stderr = nsis_check.communicate()
	
	if nsis_check.returncode != 0:
		raise CouldNotLocate("Make sure the 'makensis' executable is in your path")
	
	# JCB: need to check nsis version in stdout here?

	# Sign executables
	certificate = build.tool_config.get('ie.profile.developer_certificate')
	certificate_path = build.tool_config.get('ie.profile.developer_certificate_path')
	certificate_password = build.tool_config.get('ie.profile.developer_certificate_password')
	if certificate:
		_sign_app(build=build, 
				  certificate=certificate, 
				  certificate_path=certificate_path,
				  certificate_password=certificate_password)
	
	development_dir = path.join("development", "ie")
	release_dir = path.join("release", "ie")
	if not path.isdir(release_dir):
		os.makedirs(release_dir)

	for arch in ('x86', 'x64'):
		nsi_filename = "setup-{arch}.nsi".format(arch=arch)
		
		package = lib.PopenWithoutNewConsole('makensis {nsi}'.format(
			nsi=path.join(development_dir, "dist", nsi_filename)),
			stdout=PIPE, stderr=STDOUT, shell=True
		)
	
		out, err = package.communicate()
	
		if package.returncode != 0:
			raise IEError("problem running {arch} IE build: {stdout}".format(arch=arch, stdout=out))
		
		# move output to release directory of IE directory and sign it
		for exe in glob.glob(development_dir+"/dist/*.exe"):
			destination = path.join(release_dir, "{name}-{version}-{arch}.exe".format(
							name=build.config.get('name', 'Forge App'),
							version=build.config.get('version', '0.1'),
							arch=arch
							))
			shutil.move(exe, destination)
			if certificate:
				_sign_executable(build=build, 
								 target=destination, 
								 certificate=certificate, 
								 certificate_path=certificate_path, 
								 certificate_password=certificate_password)
		

def _generate_package_name(build):
	if "package_names" not in build.config["modules"]:
		build.config["modules"]["package_names"] = {}
	build.config["modules"]["package_names"]["ie"] =  _uuid_to_ms_clsid(build)
	return build.config["modules"]["package_names"]["ie"]


def _uuid_to_ms_clsid(build):
	md5   = hashlib.md5(build.config['uuid'])
	guid  = uuid.UUID(md5.hexdigest())
	clsid = uuid.UUID(guid.bytes_le.encode('hex'))
	return "{" + str(clsid).upper() + "}"


def _sign_app(build, certificate=None, certificate_path=None, certificate_password=""):
	'Sign all executable code'

	signtool_check = lib.PopenWithoutNewConsole('signtool /?', shell=True, stdout=PIPE, stderr=STDOUT)
	stdout, stderr = signtool_check.communicate()
	
	if signtool_check.returncode != 0:
		raise CouldNotLocate("Make sure the 'signtool' executable is in your path")

	path_win32 = path.join("development", "ie", "build", "Win32", "Release")	
	path_x64   = path.join("development", "ie", "build", "x64",	  "Release")	

	_sign_executable(build, path.join(path_win32, "bho32.dll"),
					 certificate, certificate_path, certificate_password)
	_sign_executable(build, path.join(path_win32, "forge32.dll"),
					 certificate, certificate_path, certificate_password)
	_sign_executable(build, path.join(path_win32, "forge32.exe"),
					 certificate, certificate_path, certificate_password)
	_sign_executable(build, path.join(path_win32, "frame32.dll"),
					 certificate, certificate_path, certificate_password)
	_sign_executable(build, path.join(path_x64, "bho64.dll"),
					 certificate, certificate_path, certificate_password)
	_sign_executable(build, path.join(path_x64, "forge64.dll"),
					 certificate, certificate_path, certificate_password)
	_sign_executable(build, path.join(path_x64, "forge64.exe"),
					 certificate, certificate_path, certificate_password)
	_sign_executable(build, path.join(path_x64, "frame64.dll"),
					 certificate, certificate_path, certificate_password)


def _sign_executable(build, target, certificate = None, certificate_path = None, certificate_password = ""):
	'Sign a single executable file'

	LOG.info('Signing {target}'.format(target=target))

	signtool = lib.PopenWithoutNewConsole('signtool sign /f {cert} /p {password} /v /t {time} "{target}"'.format(
		cert=path.join(certificate_path, certificate),
		password=certificate_password,
		time='http://timestamp.comodoca.com/authenticode',
		target=target),
		stdout=PIPE, stderr=STDOUT, shell=True
	)
	
	out, err = signtool.communicate()
	
	if signtool.returncode != 0:
		raise IEError("problem running IE build: {stdout}".format(stdout=out))




