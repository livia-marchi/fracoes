bw = browser_width;
bh = browser_height;

camera_set_view_size(view_camera[0], bw, bh);
//camera_set_view_pos(view_camera[0],((-bw)/2)+camera_get_view_width(view_camera[0])/2,((-bh)/2)+camera_get_view_height(view_camera[0])/2);
camera_set_view_pos(view_camera[0], 0, 0);
surface_resize(application_surface, view_wport[0], view_hport[0]);

window_set_size(bw, bh);
display_set_gui_size(bw, bh);
window_center();
display_set_gui_size(view_wview[0], view_hview[0])