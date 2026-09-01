if (browser_width != bw || browser_height != bh) {
	bw = browser_width;
	bh = browser_height;
	
	window_set_size(bw, bh);
	display_set_gui_size(bw, bh);
	window_center();
	display_set_gui_size(view_wview[0], view_hview[0])
}