pro radial_grad_filter_test

cd,'/Users/eoincarley/Data/secchi_l1/20110607/for_shanes_plot/l1/cor2/a/'
	cor2files = findfile('*.fts')
	cor2apre = sccreadfits(cor2files[0], cor2ahdr_pre)
	cor2aimg = sccreadfits('20110607_080815_1B4c2A.fts', cor2ahdr)
	cor2aimg = cor2aimg - cor2apre
	
	result = disk_nrgf( cor2aimg, cor2ahdr, 0, 0)
	
	stop
END	