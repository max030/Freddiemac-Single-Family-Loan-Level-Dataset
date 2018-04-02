import errno
import os
import threading
import urllib
import zipfile
from threading import Thread
import csv



import requests

# Constants
USERNAME = 'malshetti.s@husky.neu.edu'
PASSWORD = 'NlGoGFC9'
START_YEAR = 2005
END_YEAR = 2016
DIR_NAME = "downloaded_samples"
UNZIPPED_DIR_NAME = "unzipped_content"
login_page_url = 'https://freddiemac.embs.com/FLoan/secure/auth.php'
download_page_url = 'https://freddiemac.embs.com/FLoan/Data/download.php'
REMOVE_UNZIPPED_FILES = False
VERBOSE_MODE=True

# Decrealtions
steps_finished_num = 1
if(REMOVE_UNZIPPED_FILES):
    totalStepsCount = 12+(END_YEAR - START_YEAR + 1)*5
else:
    totalStepsCount = 11 + (END_YEAR - START_YEAR + 1) * 3

global write_lock_for_orig_file_creation
write_lock_for_orig_file_creation = False

global write_lock_for_svcg_file_creation
write_lock_for_svcg_file_creation = False

global stepsCompletedCounter
stepsCompletedCounter = 0

lock = threading.Lock()


## Functions to log/print and get the start year variable value
def log(arg):
    if(VERBOSE_MODE):
        global stepsCompletedCounter
        stepsCompletedCounter = stepsCompletedCounter + 1
        print ("Step "+str(stepsCompletedCounter)+" of "+str(totalStepsCount)+"   :"+arg)

def get_start_year():
    return START_YEAR


## Directory creation if doesn't exist
def create_directory(dir_name):
    curr_dir = os.getcwd()
    if not os.path.exists(dir_name):
        try:
            os.makedirs(dir_name)
        except OSError as e:
            if e.errno != errno.EEXIST:
                raise
    log(" SUCCESS   : "+dir_name+" directory creation succesful ")


## gets the zipped files and extrcts the contents into unzipped folder
def get_data_from_url(year):
    download = urllib.urlretrieve('https://freddiemac.embs.com/FLoan/Data/sample_' + str(year) + '.zip',
                                  DIR_NAME + '/sample_' + str(year) + '.zip')
    log(" SUCCESS   : sample_" + str(year) + ".zip download complete ")
    # unzip_files(year)
    try:
        zip_ref = zipfile.ZipFile(DIR_NAME + "/sample_" + str(year) + '.zip', 'r')
        zip_ref.extractall(UNZIPPED_DIR_NAME)
        zip_ref.close()
        log(" SUCCESS   : sample_" + str(year) + ".zip unzip complete ")
        os.remove(DIR_NAME + "/sample_" + str(year) + '.zip')
        log(" SUCCESS   : sample_" + str(year) + ".zip deletion complete ")
        write_into_consolidated_file(year, create_consolidated_file('orig'))
        write_into_consolidated_file(year, create_consolidated_file('svcg'))
        #(Thread(target=write_into_consolidated_file, args=(year, create_consolidated_file('orig'),))).start()
        #(Thread(target=write_into_consolidated_file, args=(year, create_consolidated_file('svcg'),))).start()
    except zipfile.BadZipfile:
        log(" ERROR   : Unsuccesfull to unzip "+DIR_NAME + "/sample_" + str(year) + '.zip')
        print (zipfile.BadZipfile)




## Creates a consolidated file
def create_consolidated_file(filename):
    if write_lock_for_svcg_file_creation == False or write_lock_for_orig_file_creation == False:
        with open(DIR_NAME + '/unprocessed_consolidated_sample_'+filename+'_file.csv', 'w') as file:
            file.close()
            if (write_lock_for_svcg_file_creation == False):
                global write_lock_for_svcg_file_creation
                write_lock_for_svcg_file_creation = True
            else:
                global write_lock_for_orig_file_creation
                write_lock_for_orig_file_creation = True
        log(" SUCCESS   : Creating unprocessed " + filename + " consolidated file")
        return DIR_NAME + '/unprocessed_consolidated_sample_'+filename+'_file.csv'
    else:
        return DIR_NAME + '/unprocessed_consolidated_sample_'+filename+'_file.csv'


## Removes files form the directory
def remove_file(file_path):
        os.remove(file_path)

## Writes the text file lines into csv
def write_into_consolidated_file(year, consolidated_file_path):
        fileType = consolidated_file_path.split('/')[1].split('_')[3]
        lock.acquire()
        with open(UNZIPPED_DIR_NAME + "/sample_" + fileType + "_" + str(year) + '.txt', 'r') as sourceFile:
            # sourcelines = sourceFile.readlines()
            sourcelines = sourceFile.read()
            sourcelines = sourcelines.replace(",", "_")
            sourcelines = sourcelines.replace("|", ",")
            sourcelines = sourcelines.replace(",\n", "\n")
            # sourcelines=[l for l in sourcelines if "ROW" in l]
            with open(consolidated_file_path, 'a') as destinationFile:
                # destinationFile.writelines(sourcelines)
                destinationFile.write(sourcelines)
        lock.release()
        if (REMOVE_UNZIPPED_FILES == True):
            remove_file(UNZIPPED_DIR_NAME + "/sample_" + fileType + "_" + str(year) + '.txt')
            log(" SUCCESS   : " + UNZIPPED_DIR_NAME + "/sample_" + fileType + "_" + str(
                year) + '.txt' + " deleted succesfully ")

## Main Program Execution
def start_execution():
    with requests.Session() as sess:
          log(" SUCCESS   : Program Started Succesfully")
          sess.get(login_page_url);
          php_session_cookie = sess.cookies['PHPSESSID']
          login_payload = {'username' : USERNAME, 'password' : PASSWORD,'cookie':php_session_cookie}
          response_login = sess.post(login_page_url, data = login_payload)
          download_page_payload = {'accept': 'Yes', 'action': 'acceptTandC', 'acceptSubmit': 'Continue', 'cookie': php_session_cookie}
          response_download = sess.post(download_page_url, data=download_page_payload)
          log( " SUCCESS   : Login into freddiemac.embs.com succesful ")
          create_directory(DIR_NAME)
          create_directory(UNZIPPED_DIR_NAME)
          START_YEAR = get_start_year()

          log(" SUCCESS   : Threads creation started")
          threadspool=[]
          while END_YEAR >= START_YEAR :
              #(Thread(target=get_data_from_url, args=(START_YEAR,))).start()
              newThread=(Thread(target=get_data_from_url, args=(START_YEAR,)))
              threadspool.append(newThread)
              START_YEAR += 1

          for eachThread in threadspool:
              eachThread.start()

          for eachThread in threadspool:
              eachThread.join()

def preprocessingCsvFiles(filetype):
  with open(DIR_NAME + '/unprocessed_consolidated_sample_' + filetype + '_file.csv', 'rb') as sourceCsvFile:
      rdr = csv.reader(sourceCsvFile)
      with open(DIR_NAME + '/processed_consolidated_sample_' + filetype + '_file.csv',
                'wb') as destinationCsvFile:
          wtr = csv.writer(destinationCsvFile)
          for r in rdr:
              if (filetype == 'svcg'):
                  wtr.writerow((r[0], r[1], r[2], r[3], r[4], r[5], r[7], r[8], r[9], r[10], r[11], r[13],
                                r[14], r[15], r[16], r[17], r[18], r[19], r[21], r[22]))
              else:
                  wtr.writerow((
                               r[0], r[1], r[3], r[5], r[8], r[9], r[10], r[11], r[12], r[14], r[16],
                               r[19], r[21], r[24]))

  if (REMOVE_UNZIPPED_FILES):
      remove_file(DIR_NAME + '/unprocessed_consolidated_sample_' + filetype + '_file.csv')
      log(" SUCCESS   : Deleted preprocessing unprocessed_consolidated_sample_" + filetype + "_.csv file")

def startThreadedPreprocessing():
  threadspool = []
  newsvcgThread = (Thread(target=preprocessingCsvFiles, args=("svcg",)))
  neworigThread = (Thread(target=preprocessingCsvFiles, args=("orig",)))
  threadspool.append(newsvcgThread)
  threadspool.append(neworigThread)
  for eachThread in threadspool:
      eachThread.start()
  for eachThread in threadspool:
      eachThread.join()



## Calling all the main functions
if __name__ == "__main__":
    start_execution()
    # log(" SUCCESS   : Started preprocessing unprocessed_consolidated_sample_*.csv file")
    # startThreadedPreprocessing()
    log(" SUCCESS   : Program finished")
    # os.system("python ddwnldpreprocesng2.py")
    #plotGraph()
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              