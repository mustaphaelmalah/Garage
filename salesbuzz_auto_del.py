# USAGE:
# 	- Open SalesBuz grid on the window specified in any browser
#	- Select first records manually
#	- run salezbuzz_auto_del.py "Window Title", where window title is the title of the target window
#	- leave the computer as to not interrupt the operation of the script

import pywinauto
import time
import sys

# the main title of the browser window e.g. Customer Constraints - Internet Explorer
main_wnd_title = sys.argv[1] + ' - *' 
delete_confirm_title = 'Delete'
no_selection_title = 'deleting'
page_size = 10

def wait_for_wnd(title_in, timeout_ms = 0):
	w = None
	current = time.time()
	expected = None
	if timeout_ms > 0:
		expected = time.time() + (timeout_ms / 1000.00)
	
	counter = 0
	while w is None:
		counter = counter+1
		print 'Waiting for window: ' + title_in
		try:
						#ma = pywinauto.application.Application().connect(title_re=title_in)
                        #ma = ma.window(title_re=title_in)

                        # connecting using window title directly is inaccurate
                        # so we find window handle using low-level function first,
                        # then connect using the handle
			wins = pywinauto.findwindows.find_windows(title_re=title_in)
                        print(len(wins))
                        if wins is not None and len(wins) > 0:
			    hwnd = wins[0]
                            app = pywinauto.application.Application().connect(handle=hwnd)
                            w = app.window(title_re=title_in)
                            break
		except Exception as e:
			print ('Error: ', e)
			w = None
			
		if timeout_ms > 0 and time.time() >= expected:
			if w is None:
				w = None
			break
		
	return w
	
def delete_constraints():
	for i in range(0, page_size): # delete ten records
		wnd = wait_for_wnd(main_wnd_title)
		
		# delete record
                sent = False

                while sent == False:
                    try:
                        wnd.set_focus()
                        wnd.type_keys('^+{BS}') # Ctrl+Shift+Backspace
                        
                        # wait a little for confirmation message box and press enter
                        #mw = app.window(title='Delete').Wait('exists', timeout=20, retry_interval=0.5)	
                        mw = wait_for_wnd(delete_confirm_title, 5000)
                        if mw is not None:
                            mw.set_focus()
                            mw.type_keys('{ENTER}')
                                    
                            # give it some time
                            time.sleep(0.5)

                            sent = True


                        # check if no select prompt appears and press enter to dismiss
                        mw = wait_for_wnd(no_selection_title, 5000)
                        if mw is not None:
                                mw.set_focus()
                                mw.type_keys('{ENTER}')

                                # since this indicates end of the page, return
                                return True

                    except Exception as e:
                        sent = False
		
	return True
		

# ENTRY POINT - MAIN LOOP
# Keep deleting constraints
while 1 < 2:
	r = delete_constraints() # perform constraint deletion
	if r:
		# give it two seconds to go to next page
		time.sleep(2)
		# go to next page
		wnd = wait_for_wnd(main_wnd_title)
		wnd.set_focus()
		wnd.type_keys('^{VK_NUMPAD6}')
		# give it some time to load the page
		time.sleep(3)
		
		# select first record
		#wnd.type_keys('{VK_DOWN}')
	else:
		print('Terminated')
		
	
